import Foundation
import Testing

struct GenerateWorkflowSmokeTests {
  @Test("ActionBuilderTool generates workflow for smoke package")
  func generatesWorkflowFileDirectly() throws {
    try runToolGenerationTest(additionalArguments: [])
  }

  @Test("ActionBuilderTool generates workflow when called like the plugin")
  func generatesWorkflowFileWithPluginStyleFlag() throws {
    try runToolGenerationTest(additionalArguments: ["--called-from-plugin"])
  }

  @Test("Plugin command generates workflow for smoke package")
  func generatesWorkflowFileViaPlugin() throws {
    let context = smokeTestContext()
    try? FileManager.default.removeItem(at: context.workflowFile)
    let scratchPath = context.smokePackageDirectory
      .appendingPathComponent(".build-plugin-test-\(UUID().uuidString)")
      .path

    let result = try run(
      executable: "/usr/bin/swift",
      arguments: [
        "package",
        "--scratch-path",
        scratchPath,
        "--allow-writing-to-package-directory",
        "generate-workflow"
      ],
      cwd: context.smokePackageDirectory
    )
    let output = result.output

    #expect(
      result.status == 0,
      "Plugin command failed with status \(result.status):\n\(output)"
    )

    #expect(
      FileManager.default.fileExists(atPath: context.workflowFile.path),
      "Expected generated workflow file at \(context.workflowFile.path). Command output:\n\(output)"
    )
  }

  private func runToolGenerationTest(additionalArguments: [String]) throws {
    let context = smokeTestContext()
    try? FileManager.default.removeItem(at: context.workflowFile)

    var arguments = [context.smokePackageDirectory.path]
    arguments.append(contentsOf: additionalArguments)

    let result = try run(
      executable: try actionBuilderToolExecutable(in: context.repositoryRoot).path,
      arguments: arguments,
      cwd: context.smokePackageDirectory
    )
    let output = result.output

    #expect(
      result.status == 0,
      "ActionBuilderTool failed with status \(result.status):\n\(output)"
    )

    #expect(
      FileManager.default.fileExists(atPath: context.workflowFile.path),
      "Expected generated workflow file at \(context.workflowFile.path). Command output:\n\(output)"
    )
  }

  private func actionBuilderToolExecutable(in repositoryRoot: URL) throws -> URL {
    let buildDirectory = repositoryRoot.appendingPathComponent(".build")
    guard
      let enumerator = FileManager.default.enumerator(
        at: buildDirectory,
        includingPropertiesForKeys: [.isRegularFileKey],
        options: [.skipsHiddenFiles]
      )
    else {
      throw TestError("Couldn't enumerate \(buildDirectory.path)")
    }

    for case let fileURL as URL in enumerator where fileURL.lastPathComponent == "ActionBuilderTool-tool" {
      return fileURL
    }

    throw TestError("Couldn't locate ActionBuilderTool-tool in \(buildDirectory.path)")
  }

  private func smokeTestContext() -> (repositoryRoot: URL, smokePackageDirectory: URL, workflowFile: URL) {
    let repositoryRoot = URL(fileURLWithPath: #filePath)
      .deletingLastPathComponent()
      .deletingLastPathComponent()
      .deletingLastPathComponent()

    let smokePackageDirectory = repositoryRoot
      .appendingPathComponent("Extras")
      .appendingPathComponent("PluginSmokeTestPackage")

    let workflowFile = smokePackageDirectory
      .appendingPathComponent(".github")
      .appendingPathComponent("workflows")
      .appendingPathComponent("Tests.yml")
    return (repositoryRoot, smokePackageDirectory, workflowFile)
  }

  private func run(executable: String, arguments: [String], cwd: URL) throws -> (status: Int32, output: String) {
    let process = Process()
    process.currentDirectoryURL = cwd
    process.executableURL = URL(fileURLWithPath: executable)
    process.arguments = arguments

    let outputURL = FileManager.default.temporaryDirectory
      .appendingPathComponent("action-builder-plugin-test-\(UUID().uuidString).log")
    FileManager.default.createFile(atPath: outputURL.path, contents: Data())
    let outputHandle = try FileHandle(forWritingTo: outputURL)
    defer {
      try? outputHandle.close()
      try? FileManager.default.removeItem(at: outputURL)
    }

    process.standardOutput = outputHandle
    process.standardError = outputHandle

    try process.run()
    process.waitUntilExit()

    let outputData = (try? Data(contentsOf: outputURL)) ?? Data()
    let output = String(decoding: outputData, as: UTF8.self)
    return (process.terminationStatus, output)
  }
}

private struct TestError: Error, CustomStringConvertible {
  let description: String

  init(_ description: String) {
    self.description = description
  }
}
