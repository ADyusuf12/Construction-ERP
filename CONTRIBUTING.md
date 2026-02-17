# Contributing to Earmark Systems

First off, thank you for considering contributing to Earmark Systems! Your help is invaluable in making this project better.

This document provides guidelines for contributing to the project. Please read it carefully to ensure a smooth and effective contribution process.

## Code of Conduct

This project and everyone participating in it is governed by the [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior.

## How Can I Contribute?

There are many ways to contribute, from writing tutorials or blog posts, improving the documentation, submitting bug reports and feature requests, or writing code which can be incorporated into the project itself.

## Branching Strategy

We use a three‑tier branching model:

- **main**: Production‑ready code. Only merge from `dev` when a release is ready.
- **dev**: Integration branch. Features are merged here once they are complete and tested.
- **feature/\***: Short‑lived branches for new features or bug fixes. Merge into `dev` only when the feature is complete and passes review.

### Workflow

1. Create a new branch from `dev`:
   ```bash
   git checkout dev
   git pull
   git checkout -b feature/short-description
   ```

### Suggesting Enhancements

- Open a new issue to discuss your enhancement.
- Clearly describe the proposed enhancement, why it's needed, and how it would work.

### Pull Requests

We welcome pull requests. For major changes, please open an issue first to discuss what you would like to change.

1.  **Fork the repository** and create your branch from `main`.
2.  **Branch Naming:** Use a descriptive branch name, such as `feature/new-billing-model` or `fix/user-auth-bug`.
3.  **Make your changes** in a separate branch.
4.  **Add tests** for your changes.
5.  **Ensure the test suite passes** locally.
6.  **Lint your code** using RuboCop.
7.  **Update documentation** if you have added or changed functionality.
8.  **Commit your changes** with a clear and descriptive commit message.
9.  **Push your branch** and submit a pull request to the `main` branch.
10. **Title your pull request** clearly and concisely. In the description, reference the issue it resolves (e.g., `Closes #123`).

## Development Setup

For instructions on how to set up the project locally, see the [README.md](README.md#setup-and-installation).

## Running Tests

To run the full test suite, use the following command:

```bash
bundle exec rspec
```

Please ensure that all tests are passing before you submit a pull request. If you are adding a new feature, please include tests that cover it.

## Code Style

This project uses [RuboCop](httpss://github.com/rubocop/rubocop) with the `rubocop-rails-omakase` configuration to enforce code style.

Before committing, you can run RuboCop to check for any style violations:

```bash
bundle exec rubocop
```

You can also try to auto-correct many of the offenses:

```bash
bundle exec rubocop -A
```

## Questions?

If you have any questions, feel free to open an issue and ask.

Thank you for your contribution!
