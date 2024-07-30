// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "tools",
    dependencies: [
        .package(url: "https://github.com/yonaskolb/XcodeGen.git", from: "2.42.0"),
    ],
    targets: [
    ]
)
