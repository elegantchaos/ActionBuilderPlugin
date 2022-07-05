// swift-tools-version:5.6

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 04/07/2022.
//  All code (c) 2022 - present day, Sam Deane.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import PackageDescription

let package = Package(
    name: "ActionBuilderPlugin",
    platforms: [
        .macOS(.v12)
    ],
    
    products: [
        .plugin(
            name: "ActionBuilderPlugin",
            targets: [
                "ActionBuilderPlugin"
            ]
        ),
    ],
    
    dependencies: [
        .package(url: "https://github.com/elegantchaos/ActionBuilderCore", from: "1.0.4")
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
                    .writeToPackageDirectory(reason: "Writes Workflow.yml file.")
                ]
            ),
            
            dependencies: [
                .product(name: "ActionBuilderTool", package: "ActionBuilderCore")
            ]
        ),
    ]
)
