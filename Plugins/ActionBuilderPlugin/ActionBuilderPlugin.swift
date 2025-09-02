// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 04/07/2022.
//  All code (c) 2022 - present day, Sam Deane.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import PackagePlugin

@main struct ActionBuilderPlugin: CommandPlugin {
  func run(tool: String, arguments: [String], context: PackagePlugin.PluginContext, cwd: URL) throws -> String {
    let tool = try context.tool(named: tool)

    Diagnostics.remark("Running \(tool) \(arguments.joined(separator: " ")).")

    let process = Process()
    process.executableURL = tool.url
    process.arguments = arguments
    process.currentDirectoryURL = cwd

    let outputPipe = Pipe()
    process.standardOutput = outputPipe
    try process.run()
    process.waitUntilExit()

    let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
    return String(decoding: data, as: UTF8.self)
  }

  func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {
    let packageDirectoryURL = context.package.directoryURL

    // create workflows directory if necessary
    let fm = FileManager.default
    let workflowsURL = packageDirectoryURL.appendingPathComponent(".github/workflows")
    if !fm.fileExists(atPath: workflowsURL.path) {
      Diagnostics.remark("Creating workflows directory.")
      try fm.createDirectory(at: workflowsURL, withIntermediateDirectories: true)
    }

    // run the ActionBuilder command line tool
    var toolArguments = [packageDirectoryURL.path]
    toolArguments.append(contentsOf: arguments)
    let output = try run(tool: "ActionBuilderTool", arguments: toolArguments, context: context, cwd: packageDirectoryURL)
    Diagnostics.remark(output)
  }
}
