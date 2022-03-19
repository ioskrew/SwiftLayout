#!/bin/sh

xcrun simctl delete swiftlayouttest >/dev/null

limit=""
if [ -z "$1" ]
then
      limit=100
else
      limit=$1
fi

set -e
xcrun simctl create swiftlayouttest "iPhone 13 Pro Max" >/dev/null

xcodebuild clean build -quiet -scheme SwiftLayout -sdk iphonesimulator -destination 'name=swiftlayouttest' OTHER_SWIFT_FLAGS="-Xfrontend -warn-long-function-bodies=$limit" 2>/dev/null

xcrun simctl delete swiftlayouttest >/dev/null
