# Contributing Guide for Timoni-Hub

Thank you for your interest in contributing to Timoni-Hub! Your contributions are highly valuable in helping to improve the project. Please take a moment to read and follow this guide to make your contributions as smooth as possible.

## Requirements

Before you start contributing to Timoni-Hub, please ensure that you have the following dependencies installed:

- [moon](https://moonrepo.dev/docs/install)
- [shellcheck](https://github.com/koalaman/shellcheck#installing)
- [dyff](https://github.com/homeport/dyff#installation)
- [timoni](https://timoni.sh/install/)
- [cue](https://cuelang.org/docs/install/)
- [jq](https://jqlang.github.io/jq/download/)

## Code of Conduct

Timoni-Hub follows a code of conduct outlined in [this document](https://github.com/indihouse/.github/blob/master/CODE_OF_CONDUCT.md). Please ensure all interactions and contributions adhere to these guidelines.

## Contributing to Timoni-Hub

We welcome contributions from the community! Here are some guidelines for contributing to the project.

### Pull Requests

1. Fork the [Timoni-Hub repository](https://github.com/indihouse/timoni-hub) on GitHub.
2. Clone your forked repository to your local development environment.
3. Create a new branch for your work:
   ```shell
   git checkout -b feature/your-feature
   ```
4. Make your changes, commit your work, and push the changes to your forked repository.
5. Create a pull request (PR) from your branch to the `main` branch of the original Timoni-Hub repository.
6. Ensure your PR has a clear and descriptive title.
7. Describe your changes in the PR description, providing context and reasoning for the changes.
8. Once submitted, your PR will be reviewed by the maintainers. Make sure to respond to any feedback or requested changes in a timely manner.

### Commit Messages

We follow the Conventional Commits standard for commit messages. Please adhere to the guidelines outlined in [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) when writing your commit messages.

This is important for our release workflow. **Every commit** landing on `main` will be automatically released. [Conventional Commits Next Version](https://crates.io/crates/conventional_commits_next_version) is used to automatically determine if a module release is mandatory, and if so which version should be released. It's based on commit history and modified files (module dependencies included).

### Running Checks

You can run checks on the codebase by using `moon`. To run all checks, use the following command:

```shell
moon check --all
```

To check a specific module, use:

```shell
moon check <module_name>
```

## Testing

Testing is a crucial part of ensuring the quality of Timoni-Hub. Tests for modules should be located in the `test/` directory of the module. Each test should consist of two files:

1. A `.cue` value file (e.g., `test/<test>.cue`).
2. A corresponding `.expected.yaml` file (e.g., `test/<test>.expected.yaml`).

The testing process involves generating Kubernetes manifests using the value file and comparing the results to the expected YAML.

## Project Structure

- Modules are located in the `module/<module_name>` directory.
- Libraries can be found in the `lib/<lib_name>` directory.

We appreciate your contributions to Timoni-Hub and look forward to your involvement in the project. If you have any questions or need assistance, feel free to reach out to the maintainers. Happy contributing!
