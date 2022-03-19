#!/bin/sh
set -e
xcrun simctl create swiftlayouttest "iPhone 13 Pro Max" >/dev/null

xcodebuild clean build -quiet -scheme SwiftLayout -sdk iphonesimulator -destination 'name=swiftlayouttest' OTHER_SWIFT_FLAGS="-Xfrontend -warn-long-function-bodies=100" 2>/dev/null

xcrun simctl delete swiftlayouttest >/dev/null
