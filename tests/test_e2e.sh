#!/bin/bash

TEST_PROJECT="test_run_validation"

# Helper: Ensure we are in the project root
setup() {
  if [ -f "../Makefile" ]; then
    cd ..
  fi
}

teardown_suite() {
  make down > /dev/null 2>&1
  rm -rf "projects/$TEST_PROJECT"
  rm -f make_output.txt
}

run_init_step() {
  if ! make init-project NAME="$TEST_PROJECT" > make_output.txt 2>&1; then
    cat make_output.txt
    assert_fail "Make init-project failed"
    return 1
  fi
  
  if [ ! -d "projects/$TEST_PROJECT" ]; then
    assert_fail "Directory projects/$TEST_PROJECT not created"
    return 1
  fi
  
  if [ ! -f "projects/$TEST_PROJECT/workspace.dsl" ]; then
    assert_fail "workspace.dsl missing in projects/$TEST_PROJECT"
    return 1
  fi
}

run_service_up_step() {
  make up > /dev/null 2>&1
  sleep 5
  
  check_logs() {
    make logs | grep -q "Structurizr Lite"
  }
  assert_status_code 0 check_logs || assert_fail "Structurizr Lite did not start correctly"
}

run_export_step() {
  if ! make export-diagrams > make_output.txt 2>&1; then
    cat make_output.txt
    assert_fail "Make export-diagrams failed"
    return 1
  fi
  
  local png_file=$(find projects/$TEST_PROJECT/export -name '*.png' -print -quit)
  if [ -z "$png_file" ]; then
    assert_fail "No PNG files exported"
    return 1
  fi
  
  local size=$(stat -f%z "$png_file")
  if [ "$size" -lt 1000 ]; then
    assert_fail "Exported PNG is too small ($size bytes)"
    return 1
  fi
}

run_switch_step() {
  if ! make switch-project NAME=example-project > make_output.txt 2>&1; then
    cat make_output.txt
    assert_fail "Make switch-project failed"
    return 1
  fi
  
  local current=$(cat .current_project)
  assert_matches ".*projects/example-project.*" "$current"
}

test_e2e_lifecycle() {
  assert_status_code 0 run_init_step
  assert_status_code 0 run_service_up_step
  assert_status_code 0 run_export_step
  assert_status_code 0 run_switch_step
}
