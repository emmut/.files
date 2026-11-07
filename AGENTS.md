# AGENTS.md

## Stow Package Management

### Basic Stow Commands
- **Stow a package**: `stow <package_name> --adopt`
- **Stow all packages**: `stow . --adopt`
- **Unstow a package**: `stow -D <package_name>`
- **Restow a package**: `stow -R <package_name>`
- **Check stow status**: `stow -n .` (dry-run)

### Package Structure
- Each directory represents a stow package
- Files in each package mirror the structure of $HOME
- Example: `nvim/.config/nvim/init.lua` will be linked to `~/.config/nvim/init.lua`

### Common Operations
- **Update submodules**: `git pull --recurse-submodules`
- **Add new package**: Create directory with proper structure, then `stow <package_name>`
- **Modify existing config**: Edit files in package directory, changes apply immediately

## Code Style Guidelines

### General
- Use 2 spaces for indentation (no tabs)
- Unix line endings
- Max line width: 160 characters
- Prefer single quotes for strings

### Configuration Files
- Maintain clean, readable configuration files
- Add comments for non-obvious settings
- Group related settings together
- Use consistent naming conventions

### Shell Scripts
- Use proper shebang lines
- Include error handling
- Make scripts executable
- Add usage documentation

## Testing Guidelines

### Manual Verification
- After stowing, verify files are linked correctly
- Check that applications still function as expected
- Test new configurations in isolation when possible

### Cross-Platform Considerations
- macOS-specific configurations in appropriate packages
- Consider differences between development and production environments
