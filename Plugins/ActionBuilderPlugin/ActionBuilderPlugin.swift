// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 04/07/2022.
//  All code (c) 2022 - present day, Sam Deane.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import PackagePlugin

@main struct ActionBuilderPlugin: CommandPlugin {
    func run(tool: String, arguments: [String], context: PackagePlugin.PluginContext) throws -> String {
        let tool = try context.tool(named: tool)
        
        #if DEBUG
        print("Running \(tool) \(arguments.joined(separator: " "))")
        #endif
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: tool.path.string)
        process.arguments = arguments
        process.currentDirectoryURL = URL(fileURLWithPath: context.package.directory.string)
        
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        try process.run()
        process.waitUntilExit()
        
        let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        return String(decoding: data, as: UTF8.self)
    }
    
    func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {
        let url = URL(fileURLWithPath: context.package.directory.string)
        let output = try run(tool: "ActionBuilderTool", arguments: [url.path], context: context)
        print(output)
    }
}
