workspace {

    model {
        # Users
        creator = person "Creator" "Uploads raw footage and configures branding preferences."
        editor = person "Editor" "Reviews generated clips and approves them."

        # Software System
        streamSnip = softwareSystem "StreamSnip" "Automated Video Repurposing Platform." {
            
            # Containers (Simplified)
            webPlatform = container "Web Platform" "Provides the UI, API, auth, and billing logic." "Next.js" "Web Browser" {
                # Components
                authModule = component "Auth Module" "Handles login/signup." "NextAuth.js"
                projectModule = component "Project Module" "Handles project creation and management." "Next.js API Routes"
                billingModule = component "Billing Module" "Interacts with payment gateway." "Stripe SDK"
                uploadModule = component "Upload Module" "Generates secure upload URLs." "AWS SDK"
            }

            database = container "Database" "Stores user data, project metadata, and processing status." "PostgreSQL" "Database"
            objectStore = container "Object Store" "Stores raw videos and processed clips." "S3" "Object Store"
            videoProcessor = container "Video Processor" "Processes videos: transcodes, analyzes audio, generates thumbnails." "Python/FFmpeg"
        }

        # External Systems
        aiTranscription = softwareSystem "AI Transcription Provider" "External service for speech-to-text (e.g., OpenAI Whisper)." "External System"
        paymentGateway = softwareSystem "Payment Gateway" "Handles subscription payments (e.g., Stripe)." "External System"
        emailSystem = softwareSystem "Email System" "Sends notifications to users." "External System"

        # Relationships - System Context
        creator -> streamSnip "Uploads videos and configures projects"
        editor -> streamSnip "Reviews and downloads clips"
        streamSnip -> aiTranscription "Uses for transcription"
        streamSnip -> paymentGateway "Uses for payments"
        streamSnip -> emailSystem "Sends notifications via"

        # Relationships - Containers
        creator -> webPlatform "Uses"
        editor -> webPlatform "Uses"
        
        webPlatform -> database "Reads/Writes metadata"
        webPlatform -> objectStore "Generates secure upload URLs / Reads clips"
        webPlatform -> paymentGateway "Processes payments"
        webPlatform -> emailSystem "Sends notifications"
        
        # Direct Upload
        creator -> objectStore "Uploads raw video (HTTPS)"
        editor -> objectStore "Downloads clips (HTTPS)"
        
        # Processing
        objectStore -> videoProcessor "Triggers (Event)"
        videoProcessor -> objectStore "Reads raw video / Writes clips"
        videoProcessor -> database "Updates processing status"
        videoProcessor -> aiTranscription "Sends audio for transcription"

        # Component Relationships
        authModule -> database "Reads user data"
        projectModule -> database "Reads/Writes project data"
        billingModule -> paymentGateway "Process payments"
        uploadModule -> objectStore "Generates secure URLs"

        # Deployment - Production (AWS)
        live = deploymentEnvironment "Production" {
            deploymentNode "Amazon Web Services" {
                tags "Amazon Web Services - Cloud"
                
                region = deploymentNode "US-East-1" {
                    tags "Amazon Web Services - Region"
                    
                    route53 = infrastructureNode "Route 53" {
                        tags "Amazon Web Services - Route 53"
                    }

                    appRunner = deploymentNode "App Runner" {
                        tags "Amazon Web Services - App Runner"
                        webPlatformInstance = containerInstance webPlatform
                    }
                    
                    rds = deploymentNode "RDS" {
                        tags "Amazon Web Services - RDS"
                        dbInstance = containerInstance database
                    }
                    
                    s3 = deploymentNode "S3" {
                        tags "Amazon Web Services - Simple Storage Service"
                        objectStoreInstance = containerInstance objectStore
                    }
                    
                    lambda = deploymentNode "Lambda" {
                        tags "Amazon Web Services - Lambda"
                        videoProcessorInstance = containerInstance videoProcessor
                    }
                }
            }
            
            route53 -> appRunner "Routes traffic to"
        }

        # Deployment - Development (Local)
        local = deploymentEnvironment "Development" {
            deploymentNode "Developer Laptop" {
                deploymentNode "Docker Compose" {
                    webPlatformLocal = containerInstance webPlatform
                    dbLocal = containerInstance database
                    localStack = deploymentNode "LocalStack" {
                        objectStoreLocal = containerInstance objectStore
                        videoProcessorLocal = containerInstance videoProcessor
                    }
                }
            }
        }
    }

    views {
        systemContext streamSnip "SystemContext" {
            include *
            autoLayout
        }

        container streamSnip "Containers" {
            include *
            autoLayout
        }
        
        component webPlatform "Components" {
            include *
            autoLayout
        }

        deployment streamSnip live "Deployment-Prod" {
            include *
            autoLayout
        }

        deployment streamSnip local "Deployment-Dev" {
            include *
            autoLayout
        }

        styles {
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Person" {
                shape Person
                background #08427b
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
            element "Database" {
                shape Cylinder
            }
            element "Web Browser" {
                shape WebBrowser
            }
            element "External System" {
                background #999999
                color #ffffff
            }
        }
        
        theme https://static.structurizr.com/themes/amazon-web-services-2023.01.31/theme.json
    }
}
