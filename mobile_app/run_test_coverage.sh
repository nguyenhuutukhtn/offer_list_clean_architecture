#!/bin/bash

# File: run_test_coverage.sh

# Exit immediately if a command exits with a non-zero status.
set -e

# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Run Flutter tests with coverage
log "Running tests with coverage..."
flutter test --coverage

# Check if lcov is installed
if ! command -v lcov &> /dev/null
then
    log "lcov could not be found. Please install lcov manually."
    log "For macOS: brew install lcov"
    log "For Ubuntu/Debian: sudo apt-get install lcov"
    exit 1
fi

# Generate HTML report
log "Generating HTML report..."
genhtml coverage/lcov.info -o coverage/html

# Check if the HTML report was generated
if [ ! -f coverage/html/index.html ]; then
    log "Error: Coverage report was not generated. Check if there were any test failures."
    exit 1
fi

# Open the coverage report
log "Attempting to open coverage report..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    open coverage/html/index.html
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open coverage/html/index.html
elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    start coverage/html/index.html
else
    log "Unsupported operating system. Please open coverage/html/index.html manually."
fi

log "Script execution completed. If the report didn't open automatically, please open coverage/html/index.html in your web browser."