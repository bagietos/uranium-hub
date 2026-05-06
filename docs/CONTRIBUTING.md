# Contributing to Uranium Hub

Thank you for your interest in contributing to Uranium Hub! This document provides guidelines for contributing to the project.

## Code of Conduct

- Professional and respectful communication
- Focus on code quality and functionality
- No harmful, hateful, or offensive content
- Constructive feedback and discussion

## Getting Started

1. Fork the repository
2. Clone your fork
3. Create a feature branch: `git checkout -b feature/your-feature-name`
4. Make your changes
5. Test thoroughly
6. Commit with clear messages
7. Push to your fork
8. Create a pull request

## Development Guidelines

### Code Style

- Use clear, descriptive variable names
- Add comments above functions explaining purpose
- Follow the existing code structure
- Use modular approach
- No emojis or emoticons

### File Organization

New modules should follow this structure:

```lua
--[[
    URANIUM HUB - Feature Name
    Brief description of what this module does
]]

local ModuleName = {}

-- ============================================================================
-- SECTION TITLE
-- ============================================================================

--[[
    FunctionName: Description of what this function does
    @param param1: Description of parameter
    @return: Description of return value
]]
function ModuleName:FunctionName(param1)
    -- Implementation
end

return ModuleName
```

### Naming Conventions

- **Modules**: descriptive.lua (e.g., noclip.lua)
- **Functions**: CamelCase (e.g., SetCharacter)
- **Variables**: camelCase (e.g., isEnabled)
- **Constants**: UPPER_CASE (e.g., MAX_SPEED)
- **Configuration keys**: CamelCase

### Configuration

All settings should be added to `src/utils/config.lua`:

```lua
Config.NewFeature = {
    Name = "Feature Name",
    DefaultEnabled = false,
    -- Other settings
}
```

## Types of Contributions

### Bug Fixes

1. Open an issue describing the bug
2. Create a fix with clear commit message
3. Test in multiple scenarios
4. Submit pull request with bug fix

### New Features

1. Discuss in issue first (optional but recommended)
2. Create feature branch
3. Implement with modular structure
4. Add configuration support
5. Update relevant documentation
6. Submit pull request

### Documentation

- Fix typos and improve clarity
- Add examples where helpful
- Update diagrams if needed
- Keep documentation in sync with code

### Testing

- Test features in-game before submitting
- Verify all UI elements work
- Test on different executors if possible
- Test edge cases and error conditions

## Pull Request Process

1. **Title**: Clear, descriptive PR title
   - Good: "Add teleport feature to Movement tab"
   - Bad: "Update stuff"

2. **Description**: Explain changes
   - What changes were made
   - Why these changes were needed
   - How to test the changes
   - Any breaking changes

3. **Code Review**: Address feedback
   - Respond to comments
   - Make requested changes
   - Re-request review when done

4. **Merge**: PR merged after approval

## Commit Message Format

```
Brief summary (50 chars max)

Longer explanation if needed, wrapping at ~72 chars.
Explain what changed and why, not how.

- Bullet points are fine
- For complex changes
```

### Good Commit Messages

- `Add fly speed configuration slider`
- `Fix noclip not re-enabling collisions on disable`
- `Refactor feature manager for better organization`
- `Update documentation with new API`

### Avoid

- `Fix bug`
- `Update`
- `asdf`
- `WIP`

## Issue Reporting

### Bug Reports

Include:
- Clear description of the bug
- Steps to reproduce
- Expected behavior
- Actual behavior
- Your executor version
- Game context (if applicable)

### Feature Requests

Include:
- Clear description of feature
- Use case / why it's needed
- Suggested implementation (if any)
- Any relevant context

## Testing Checklist

Before submitting:
- [ ] Feature works as intended
- [ ] No console errors
- [ ] UI elements function correctly
- [ ] All toggles work
- [ ] Settings persist
- [ ] No conflicts with other features
- [ ] Code follows style guidelines
- [ ] Comments are present
- [ ] No unused code
- [ ] Documentation updated (if needed)

## Documentation Updates

When making changes:
- Update README.md if user-facing
- Update ARCHITECTURE.md for structural changes
- Add inline code comments
- Update relevant .md files in docs/

## Performance Considerations

- Minimize RunService connections
- Use appropriate service for timing (Stepped vs RenderStepped)
- Disconnect connections when features disable
- Test for memory leaks
- Consider CPU impact

## Security Guidelines

- Never execute untrusted code
- Validate all inputs
- Handle errors gracefully
- No storing sensitive information
- Be transparent about what the script does

## Review Criteria

Pull requests are reviewed for:
- Code quality and style
- Adherence to project structure
- Documentation completeness
- Testing thoroughness
- Performance impact
- Security considerations
- Backward compatibility

## Questions?

- Check existing documentation
- Review closed issues for similar topics
- Open an issue for discussion
- Respectfully engage with community

## Recognition

Contributors will be recognized:
- In commit history
- In pull request discussions
- In CONTRIBUTORS file (planned)

## License

By contributing, you agree that your contributions will be licensed under the same MIT License as the project.

---

Thank you for contributing to Uranium Hub!

**Uranium Hub v1.0** | Contribution Guidelines
