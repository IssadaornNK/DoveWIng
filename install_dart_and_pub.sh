#!/bin/bash

# Set Dart SDK URL
DART_SDK_URL="https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-x64-release.zip"

# Create a temporary directory for the Dart SDK
mkdir -p /app/dart-sdk

# Download Dart SDK
curl -o /tmp/dartsdk.zip $DART_SDK_URL

# Unzip Dart SDK
unzip /tmp/dartsdk.zip -d /app/dart-sdk

# Add Dart SDK to PATH
export PATH="/app/dart-sdk/dart-sdk/bin:$PATH"

# Verify Dart SDK installation
dart --version

# Check if pub is available
if ! command -v dart pub &> /dev/null
then
    echo "ERROR: pub could not be found."
    exit 1
else
    echo "pub is installed successfully."
fi

# Run pub get
dart pub get