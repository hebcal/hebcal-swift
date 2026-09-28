// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "Hebcal",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .watchOS(.v9),
        .tvOS(.v16),
    ],
    products: [
        .library(name: "Hebcal", targets: ["Hebcal"]),
    ],
    targets: [
        .target(name: "Hebcal"),
        .testTarget(name: "HebcalTests", dependencies: ["Hebcal"]),
    ],
    swiftLanguageModes: [.v6]
)
