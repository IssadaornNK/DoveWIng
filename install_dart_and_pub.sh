#!/bin/bash

# Set Dart SDK URL
DART_SDK_URL="https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-x64-release.zip"

# Download Dart SDK
curl -O $DART_SDK_URL

# Unzip Dart SDK
unzip dartsdk-linux-x64-release.zip -d /app

# Add Dart SDK to PATH
export PATH="/app/dart-sdk/bin:$PATH"

# Verify Dart SDK installation
dart --version

# Check if pub is available
if ! command -v pub &> /dev/null
then
    echo "ERROR: pub could not be found."
    exit 1
else
    echo "pub is installed successfully."
fi

# Run pub get
pub get