// swift-tools-version:6.2

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 04/07/2022.
//  All code (c) 2022 - present day, Sam Deane.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import PackageDescription

let package = Package(
  name: "ActionBuilderPlugin",
  platforms: [
    .macOS(.v26)
  ],

  products: [
    .plugin(
      name: "ActionBuilderPlugin",
      targets: [
        "ActionBuilderPlugin"
      ]
    )
  ],

  dependencies: [
    .package(url: "https://github.com/elegantchaos/ActionBuilderCore.git", from: "2.1.3"),
  ],

  targets: [
    .plugin(
      name: "ActionBuilderPlugin",

      capability: .command(
        intent: .custom(
          verb: "generate-workflow",
          description: "Generates a Github Actions workflow file for the package."
        ),

        permissions: [
          .writeToPackageDirectory(reason: "Generates/updates Workflow.yml and README.md.")
        ]
      ),

      dependencies: [
        .product(name: "ActionBuilderTool", package: "ActionBuilderCore")
      ]
    )
  ]
)
