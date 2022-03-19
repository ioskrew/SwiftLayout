#!/bin/sh
xcrun simctl create swiftlayouttest "iPhone 13 Pro Max"
xcodebuild clean test -quiet -scheme SwiftLayout -sdk iphonesimulator -destination 'name=swiftlayouttest' OTHER_SWIFT_FLAGS="-Xfrontend -debug-time-function-bodies -Xfrontend -warn-long-expression-type-checking=10 -Xfrontend -warn-long-function-bodies=10" | grep -e '^[0-9]'
xcrun simctl delete swiftlayouttest
