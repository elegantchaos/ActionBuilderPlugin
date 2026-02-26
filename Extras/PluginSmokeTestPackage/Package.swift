// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "PluginSmokeTestPackage",
  platforms: [.macOS(.v26)],
  dependencies: [
    .package(path: "../..")
  ],
  targets: [
    .target(
      name: "PluginSmokeTestPackage"
    )
  ]
)
