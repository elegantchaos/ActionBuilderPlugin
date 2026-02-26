// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 04/07/2022.
//  All code (c) 2022 - present day, Sam Deane.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import PackagePlugin

@main struct ActionBuilderPlugin: CommandPlugin {
  private enum PluginError: Error, CustomStringConvertible {
    case toolFailed(name: String, status: Int32, output: String)
    case workflowMissing(path: String, output: String)

    var description: String {
      switch self {
      case let .toolFailed(name, status, output):
        return "\(name) exited with status \(status).\n\(output)"
      case let .workflowMissing(path, output):
        return "Expected generated workflow at \(path), but it was not found.\n\(output)"
      }
    }
  }

  private struct Settings: Decodable {
    var workflow: String?
  }

  func run(tool: String, arguments: [String], context: PackagePlugin.PluginContext, cwd: URL) async throws -> (status: Int32, output: String) {
    let resolvedTool = try context.tool(named: tool)

    Diagnostics.remark("Running \(resolvedTool.url.lastPathComponent) \(arguments.joined(separator: " "))")

    let process = Process()
    process.executableURL = resolvedTool.url
    process.arguments = arguments
    process.currentDirectoryURL = cwd

    let outputPipe = Pipe()
    process.standardOutput = outputPipe
    process.standardError = outputPipe
    try process.run()
    process.waitUntilExit()

    let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(decoding: data, as: UTF8.self)
    return (process.terminationStatus, output)
  }

  private func expectedWorkflowName(in packageDirectoryURL: URL) -> String {
    let settingsURL = packageDirectoryURL.appendingPathComponent(".actionbuilder.json")
    guard let data = try? Data(contentsOf: settingsURL),
      let settings = try? JSONDecoder().decode(Settings.self, from: data),
      let workflow = settings.workflow,
      !workflow.isEmpty
    else {
      return "Tests"
    }
    return workflow
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

    // Run the ActionBuilder command line tool.
    var toolArguments = [packageDirectoryURL.path, "--called-from-plugin"]
    toolArguments.append(contentsOf: arguments)

    let result = try await run(
      tool: "ActionBuilderTool",
      arguments: toolArguments,
      context: context,
      cwd: packageDirectoryURL
    )

    if result.status != 0 {
      let error = PluginError.toolFailed(
        name: "ActionBuilderTool",
        status: result.status,
        output: result.output
      )
      Diagnostics.error(error.description)
      throw error
    }

    let workflowName = expectedWorkflowName(in: packageDirectoryURL)
    let expectedWorkflowPath = workflowsURL.appendingPathComponent("\(workflowName).yml").path
    guard fm.fileExists(atPath: expectedWorkflowPath) else {
      let error = PluginError.workflowMissing(path: expectedWorkflowPath, output: result.output)
      Diagnostics.error(error.description)
      throw error
    }

    Diagnostics.remark(result.output)
  }
}
