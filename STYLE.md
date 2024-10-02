# Style Guide for Mazilon

This style guide outlines the coding conventions of the Mazilon project. Adhering to these guidelines will ensure code clarity and consistency throughout the application.

## Dart and Flutter Code Conventions

### Formatting

- **Indentation**: Use 2 spaces for indentation, not tabs.
- **Braces**: Place the opening brace on the same line as the control statement and the closing brace on a new line.
- **Max Line Length**: Try to keep the line length to 80 characters. If more is necessary for readability, do not exceed 120 characters.

### Naming Conventions

- **Classes**: Class names should be in UpperCamelCase.
- **Methods and Variables**: Use lowerCamelCase for method, variable, and parameter names.
- **Constants**: Use lowercase with underscores (e.g., `final_max_width`).
- **Enums**: Enum names should be in UpperCamelCase, and enum values should be in lowerCamelCase.

### Comments

- **Documentation**: Use `///` for public API documentation. Comments should be clear and concise and written in English.
- **Inline Comments**: Use `//` for inline comments and place them above the code block they refer to, not at the end of the line.

### Best Practices

- **Functions**: Keep functions short and focused. Each function should perform a single task.
- **Widgets**: Break down large widgets into smaller sub-widgets to improve code readability and reusability.
- **Avoid `null` where possible**: Leverage Dart's null safety features. Use defaults or assertions to ensure non-nullability where it makes sense.

## Git Commit Messages

- **Verbosity**: Start commit messages with a verb in the present tense, such as "Add", "Fix", or "Remove", followed by a brief description.
- **Detailing**: Describe what changed and why. If the change relates to a specific issue or task, reference it in the commit.

## Pull Requests

- **Branch Naming**: Use descriptive branch names that reflect the feature or fix, prefixed with `feature/` or `fix/`.
- **PR Descriptions**: Include a summary of changes and their motivation. Link any relevant issues.
- **Review Process**: Wait for at least one review before merging. Use comments to address review concerns.

## Testing

- **Unit Tests**: Write unit tests for all new code where feasible. Use meaningful test case descriptions.
- **Integration Tests**: For UI changes, include integration tests to verify functionality across different screens and interactions.

## Resources

- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Documentation](https://flutter.dev/docs)

This style guide is a living document and will evolve as the project grows and we learn what works best for us as a team.
