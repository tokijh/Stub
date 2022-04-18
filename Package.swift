// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Stub",
  platforms: [
    .macOS(.v10_10), .iOS(.v9), .tvOS(.v9), .watchOS(.v2),
  ],
  products: [
    .library(name: "Stub", targets: ["Stub"]),
  ],
  targets: [
    .target(name: "Stub"),
    .testTarget(name: "StubTests", dependencies: ["Stub"]),
  ]
)
