const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

const STRUCTURIZR_URL = process.env.STRUCTURIZR_URL || 'http://structurizr-lite:8080';
const OUTPUT_DIR = process.env.OUTPUT_DIR || '/output';

(async () => {
    console.log(`Connecting to ${STRUCTURIZR_URL}...`);

    // 1. Fetch workspace.json to get the list of views
    // We use the browser to fetch it to avoid needing 'node-fetch' or 'axios' dependencies
    const browser = await puppeteer.launch({
        args: ['--no-sandbox', '--disable-setuid-sandbox'],
        headless: 'new'
    });

    try {
        const page = await browser.newPage();

        // Set viewport to a reasonable size for high-res screenshots
        await page.setViewport({ width: 2000, height: 1500, deviceScaleFactor: 2 });

        console.log('Loading Structurizr Lite UI...');
        await page.goto(`${STRUCTURIZR_URL}`, { waitUntil: 'networkidle0' });

        // Wait for the structurizr object to be available
        await page.waitForFunction(() => window.structurizr && window.structurizr.workspace);

        const workspaceJson = await page.evaluate(() => {
            return window.structurizr.workspace;
        });

        if (!workspaceJson || !workspaceJson.views) {
            throw new Error('Could not retrieve workspace definition from UI.');
        }

        const views = [
            ...(workspaceJson.views.systemLandscapeViews || []),
            ...(workspaceJson.views.systemContextViews || []),
            ...(workspaceJson.views.containerViews || []),
            ...(workspaceJson.views.componentViews || []),
            ...(workspaceJson.views.dynamicViews || []),
            ...(workspaceJson.views.deploymentViews || []),
            ...(workspaceJson.views.filteredViews || [])
        ];

        console.log(`Found ${views.length} views.`);

        // Ensure output directory exists
        if (!fs.existsSync(OUTPUT_DIR)) {
            fs.mkdirSync(OUTPUT_DIR, { recursive: true });
        }

        // 2. Iterate and screenshot
        for (const view of views) {
            const viewKey = view.key;
            console.log(`Exporting view: ${viewKey}...`);

            // Navigate to the diagram viewer using hash for deep linking
            // URL pattern: /workspace/diagrams#key
            await page.goto(`${STRUCTURIZR_URL}/workspace/diagrams#${viewKey}`, { waitUntil: 'networkidle0' });

            // Wait for the diagram to be rendered (SVG element)
            try {
                await page.waitForSelector('#structurizr-diagram-target svg', { timeout: 5000 });
            } catch (e) {
                console.warn(`Timeout waiting for SVG on view ${viewKey}, attempting screenshot anyway.`);
            }

            // Give it a moment to settle (animations, layout)
            await new Promise(r => setTimeout(r, 1000));

            const filename = path.join(OUTPUT_DIR, `${viewKey}.png`);

            // Take screenshot of the diagram area or full page
            // Ideally we clip to the SVG, but full page is safer to capture everything
            await page.screenshot({ path: filename, fullPage: true });
            console.log(`Saved to ${filename}`);
        }

        console.log('Export complete.');

    } catch (error) {
        console.error('Export failed:', error);
        process.exit(1);
    } finally {
        await browser.close();
    }
})();
