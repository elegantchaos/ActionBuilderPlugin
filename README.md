[comment]: <> (Header Generated by ActionStatus 2.0.6 - 494)

[![Test results][tests shield]][actions] [![Latest release][release shield]][releases] [![swift 5.6 shield]][swift] ![Platforms: macOS][platforms shield]

[release shield]: https://img.shields.io/github/v/release/elegantchaos/ActionBuilderPlugin
[platforms shield]: https://img.shields.io/badge/platforms-macOS-lightgrey.svg?style=flat "macOS"
[tests shield]: https://github.com/elegantchaos/ActionBuilderPlugin/workflows/Tests/badge.svg
[swift 5.6 shield]: https://img.shields.io/badge/swift-5.6-F05138.svg "Swift 5.6"

[swift]: https://swift.org
[releases]: https://github.com/elegantchaos/ActionBuilderPlugin/releases
[actions]: https://github.com/elegantchaos/ActionBuilderPlugin/actions

[comment]: <> (End of ActionStatus Header)

# ActionBuilderPlugin

A Swift Package Manager command which builds a Github Actions workflow for the current package.

By default the workflow file will be generated at `.github/workflows/Tests.yml`, and be based on details obtained by examining the `Package.swift` file -- although this
can be configured.

See [ActionBuilderCore](https://github.com/elegantchaos/ActionBuilderCore) for full details on what the workflow contains and how to alter it.

## Usage

Add this repo to your package dependencies:

```Swift
    dependencies: [
        .package(url: "https://github.com/elegantchaos/ActionBuilderPlugin.git", from: "1.0.2"),
        /* other dependencies here... */ 
    ],
```

Invoke the tool from the command line:

`swift package plugin --allow-writing-to-package-directory generate-workflow`


## Configuration

By default, the plugin attempts to guess exactly what the workflow should do, based on the contents of the `Package.swift` file.

If you want more control though, you can add a `.actionbuilder.json` file at the root of the package. This lets you specify a number of options when generating the workflow file.

See [ActionBuilderCore](https://github.com/elegantchaos/ActionBuilderCore#configuration) for full details. 

If you pass the `--create-config` flag to the plugin itself, it will make a new empty config file for you.
