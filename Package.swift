// swift-tools-version:5.7

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
    ],
    
    targets: [
        .plugin(
            name: "ActionBuilderPlugin",
            
            capability: .command(
                intent: .custom(
                    verb: "command",
                    description: "command description"
                ),
                
                permissions: [
                    .writeToPackageDirectory(reason: "write reason")
                ]
            ),
            
            dependencies: [
            ]
        ),
    ]
)
