#!/bin/bash
DART_SDK_URL="https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-x64-release.zip"
curl -O $DART_SDK_URL
unzip dartsdk-linux-x64-release.zip -d /app/
export PATH=$PATH:/app/dart-sdk/bin