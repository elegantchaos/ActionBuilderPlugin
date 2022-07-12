# ActionBuilderPlugin

A Swift Package Manager command which builds a Github Actions workflow for the current package.

By default the workflow file will be generated at `.github/workflows/Tests.yml`, and be based on details obtained by examining the `Package.swift` file -- although this
can be configured.

See [ActionBuilderCore](https://github.com/elegantchaos/ActionBuilderCore) for full details on what the workflow contains and how to alter it.

## Usage

Add this repo to your package dependencies:

```Swift
    dependencies: [
        .package(url: "https://github.com/elegantchaos/ActionBuilderPlugin", from: "1.0.2"),
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
