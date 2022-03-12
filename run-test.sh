#!/bin/sh
xcrun simctl create swiftlayouttest "iPhone 13 Pro Max"
xcodebuild test -scheme SwiftLayout -sdk iphonesimulator -destination 'name=swiftlayouttest'
xcodebuild test -scheme SwiftLayout -sdk macosx -destination 'platform=macOS'
xcrun simctl delete swiftlayouttest
