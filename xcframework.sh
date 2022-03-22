echo "Cleaning..."
rm -rf ./build
rm -rf ./Binary

echo "Create xcodeproj"
cp -f PackageForXCFramework.swift Package.swift
swift package generate-xcodeproj

echo "Archiving..."
xcodebuild clean archive -scheme SwiftLayout-Package -archivePath "./build/ios.xcarchive" -sdk iphoneos -destination generic/platform=iOS SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES
xcodebuild clean archive -scheme SwiftLayout-Package  -archivePath "./build/ios_sim.xcarchive" -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "Create XCFramework"
xcodebuild -create-xcframework \
-framework "./build/ios.xcarchive/Products/Library/Frameworks/SwiftLayout.framework" \
-framework "./build/ios_sim.xcarchive/Products/Library/Frameworks/SwiftLayout.framework" \
-output "./Binary/SwiftLayoutFramework.xcframework"

rm -rf ./SwiftLayout.xcodeproj

echo "Cleaning..."
rm -rf ./build

cp -f PackagePublic.swift Package.swift
