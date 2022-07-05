# ActionBuilderPlugin

A Swift Package Manager command which builds a Github Actions workflow for the current package.

By default the workflow file will be generated at `.github/workflows/Tests.yml`, and be based on details obtained by examining the `Package.swift` file -- although this
can be configured.

See [ActionBuilderCore](https://github.com/elegantchaos/ActionBuilderCore) for full details on what the workflow contains and how to alter it.
