#!/bin/sh
xcrun simctl create swiftlayouttest "iPhone 13 Pro Max" >/dev/null
#xcodebuild clean build -quiet -scheme SwiftLayout -sdk iphonesimulator -destination 'name=01089865370' OTHER_SWIFT_FLAGS="-Xfrontend -debug-time-function-bodies -Xfrontend -warn-long-expression-type-checking=10 -Xfrontend -warn-long-function-bodies=10"
#xcodebuild clean build -quiet -scheme SwiftLayout -sdk iphonesimulator -destination 'name=swiftlayouttest' OTHER_SWIFT_FLAGS="-Xfrontend -debug-time-function-bodies -Xfrontend -warn-long-expression-type-checking=10 -Xfrontend -warn-long-function-bodies=10" |
#       grep -o "^\d*.\d*ms\t[^$]*$" |
#       awk '!visited[$0]++' |
#       sed -e "s|$(pwd)/||" |
#       grep -v "Tests" |
#       sort -n
# xcodebuild test -scheme SwiftLayout -sdk iphonesimulator -destination 'name=swiftlayouttest' -only-testing:SwiftLayoutTests/PerformanceTests/testPerformanceLayoutableAndLayout 2>/dev/null | grep testPerformanceLayoutableAndLayout
#xcrun simctl delete swiftlayouttest >/dev/null

xcodebuild clean build -quiet -scheme SwiftLayout -sdk iphonesimulator -destination 'name=swiftlayouttest' OTHER_SWIFT_FLAGS="-Xfrontend -warn-long-expression-type-checking=10" 2>/dev/null
xcodebuild clean build -quiet -scheme SwiftLayout -sdk iphonesimulator -destination 'name=swiftlayouttest' OTHER_SWIFT_FLAGS="-Xfrontend -warn-long-function-bodies=10" 2>/dev/null
xcodebuild clean build -quiet -scheme SwiftLayout -sdk iphonesimulator -destination 'name=swiftlayouttest' OTHER_SWIFT_FLAGS="-Xfrontend -debug-time-function-bodies -Xfrontend -warn-long-expression-type-checking=100 -Xfrontend -warn-long-function-bodies=100" 2>/dev/null |
       grep -o "^\d*.\d*ms\t[^$]*$" |
       awk '!visited[$0]++' |
       sed -e "s|$(pwd)/||" |
       grep -v "Tests" |
       sort -n
xcrun simctl delete swiftlayouttest >/dev/null
