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

# Run dart pub get
if command -v dart &> /dev/null
then
    echo "Running dart pub get"
    l pub get
else
    echo "ERROR: dart could not be found."
    exit 1
fi