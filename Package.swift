// swift-tools-version: 6.0
// AppTemplate — a native macOS (Apple Silicon, macOS 14+) app template.
// Swift 6 strict concurrency. SwiftUI-first. AppKit only where SwiftUI is insufficient.
//
// This is a TEMPLATE: clone, then run `Scripts/rename.sh "MyApp" "com.myapp"` to rebrand
// every target, module, and bundle identifier in one step.

import PackageDescription

let librarySwiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6)
]

// The executable entry uses @main (not a main.swift file), so it must be parsed as a library.
let executableSwiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .unsafeFlags(["-parse-as-library"])
]

let package = Package(
    name: "AppTemplate",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "AppTemplate", targets: ["AppTemplate"]),
        .library(name: "AppTemplateCore", targets: ["AppTemplateCore"])
    ],
    dependencies: [
        // Add SPM dependencies here, e.g.:
        // .package(url: "https://github.com/apple/swift-atomics.git", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "AppTemplateCore",
            dependencies: [],
            swiftSettings: librarySwiftSettings
        ),
        .executableTarget(
            name: "AppTemplate",
            dependencies: ["AppTemplateCore"],
            swiftSettings: executableSwiftSettings
        ),
        .testTarget(
            name: "AppTemplateCoreTests",
            dependencies: ["AppTemplateCore"],
            swiftSettings: librarySwiftSettings
        ),
        .testTarget(
            name: "AppTemplateTests",
            dependencies: ["AppTemplate"],
            swiftSettings: librarySwiftSettings
        )
    ]
)
