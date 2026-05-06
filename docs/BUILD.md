# Build Guide - Uranium Hub

Instructions for building Uranium Hub for distribution and deployment.

## Overview

Uranium Hub can be distributed in two ways:

1. **Modular** - Users load src/main.lua (requires module structure)
2. **Single File** - Users load uranium-hub.lua (everything included)

This guide covers both approaches and the build process.

## Build Process

### Automated Build

We provide `uranium-hub.lua` as a pre-built single-file distribution.

### Manual Build Process

If you need to rebuild uranium-hub.lua from modular source:

1. **Concatenate in order**:
   ```
   Config (src/utils/config.lua)
   Helpers (src/utils/helpers.lua)
   Noclip (src/modules/noclip.lua)
   Fly (src/modules/fly.lua)
   FeatureManager (src/modules/feature_manager.lua)
   UIWindow (src/ui/window.lua)
   UITabs (src/ui/tabs.lua)
   Main (src/main.lua)
   ```

2. **Remove require() statements** and replace with module references

3. **Add header and footer**

4. **Test thoroughly**

### Build Script

Example build script (pseudocode):

```lua
-- Build script to combine modules
local files = {
    "src/utils/config.lua",
    "src/utils/helpers.lua",
    "src/modules/noclip.lua",
    "src/modules/fly.lua",
    "src/modules/feature_manager.lua",
    "src/ui/window.lua",
    "src/ui/tabs.lua",
    "src/main.lua"
}

local output = ""

-- Add header
output = output .. "--[[ URANIUM HUB v1.0 SINGLE FILE DISTRIBUTION ]]\n\n"

-- Concatenate files
for _, file in ipairs(files) do
    local content = readfile(file)
    output = output .. content .. "\n\n"
end

-- Write output
writefile("uranium-hub.lua", output)
```

## Distribution Methods

### Option 1: GitHub

1. Create repository: `github.com/yourusername/uranium-hub`
2. Push code to main branch
3. Share link: `https://github.com/yourusername/uranium-hub`

**For raw file link**:
```
https://raw.githubusercontent.com/yourusername/uranium-hub/main/src/main.lua
```

### Option 2: Pastebin

1. Create account on pastebin.com
2. Upload uranium-hub.lua
3. Set to public
4. Share paste ID

**Usage**:
```lua
loadstring(game:HttpGet("https://pastebin.com/raw/PASTE_ID"))()
```

### Option 3: Roblox Script Hub

1. Register on script hub platform
2. Upload uranium-hub.lua
3. Add description and tags
4. Publish

### Option 4: Self-Hosted

1. Host on your own server/website
2. Set correct MIME type: `text/plain` or `application/lua`
3. Share direct link

**Usage**:
```lua
loadstring(game:HttpGet("https://your-domain.com/uranium-hub.lua"))()
```

## Version Management

### Versioning Scheme

Follow semantic versioning: `MAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes, significant features
- **MINOR**: New features, improvements
- **PATCH**: Bug fixes, small changes

### Update Process

1. **Update version in config.lua**:
   ```lua
   Config.UI.Version = "1.1.0"
   ```

2. **Update documentation** (README.md, CHANGELOG if present)

3. **Rebuild uranium-hub.lua**

4. **Test thoroughly** in multiple scenarios

5. **Commit and tag**:
   ```bash
   git add .
   git commit -m "Release v1.1.0"
   git tag -a v1.1.0 -m "Version 1.1.0"
   git push origin main --tags
   ```

6. **Create release notes** on GitHub

## Pre-Release Checklist

Before publishing a new version:

- [ ] All features tested
- [ ] No console errors
- [ ] Documentation updated
- [ ] Version number updated
- [ ] uranium-hub.lua rebuilt and tested
- [ ] Code reviewed
- [ ] Performance verified
- [ ] Edge cases tested
- [ ] Commit messages clear
- [ ] Git tags created

## Testing Checklist

Test before release:

- [ ] Script loads without errors
- [ ] UI appears on execution
- [ ] Menu toggles with Right Shift
- [ ] All tabs accessible
- [ ] Noclip enables/disables
- [ ] Fly enables/disables
- [ ] Speed slider works
- [ ] Disable all button works
- [ ] Character respawn resets features
- [ ] No memory leaks
- [ ] Performance acceptable
- [ ] Works in multiple games

## Deployment Strategies

### Beta Release

1. Distribute to small group
2. Collect feedback
3. Fix issues
4. Release stable version

### Staged Rollout

1. Release to early adopters
2. Monitor for issues
3. Expand distribution gradually
4. Full release when stable

### Direct Release

1. Test thoroughly internally
2. Release to all users
3. Monitor community feedback
4. Patch issues quickly

## Rollback Procedure

If critical issue found:

1. **Identify issue** and affected versions
2. **Create hotfix branch**: `git checkout -b hotfix/v1.1.1`
3. **Fix the issue** in code
4. **Test thoroughly**
5. **Merge and release**: 
   ```bash
   git commit -m "Fix critical issue"
   git tag -a v1.1.1 -m "Hotfix v1.1.1"
   git push origin main --tags
   ```
6. **Notify users** of available update

## Performance Optimization

### Before Release

Run these checks:

1. **Memory profiling**
   - Load script
   - Monitor memory usage
   - Check for leaks after enable/disable

2. **CPU profiling**
   - Check CPU usage when idle
   - Check with Noclip enabled
   - Check with Fly enabled

3. **Startup time**
   - Measure script load time
   - Measure UI creation time
   - Measure first interaction time

## Documentation Update

When releasing new version:

1. **Update README.md**
   - New features section
   - Updated screenshots (if applicable)
   - New requirements or dependencies

2. **Update ARCHITECTURE.md**
   - Document structural changes
   - Update diagrams if needed
   - Note new modules

3. **Create CHANGELOG.md** (optional)
   ```markdown
   # Changelog

   ## v1.1.0 (Date)
   - Added feature X
   - Fixed bug Y
   - Improved performance Z
   ```

4. **Update CONTRIBUTING.md**
   - New contribution guidelines if changed
   - Updated development setup

## Distribution Checklist

Final checklist before distributing:

- [ ] uranium-hub.lua tested and working
- [ ] Documentation complete and accurate
- [ ] Version number updated everywhere
- [ ] LICENSE included
- [ ] README complete with usage instructions
- [ ] Installation guide clear
- [ ] All commits pushed to repository
- [ ] Git tags created
- [ ] Release notes written
- [ ] Distribution links ready
- [ ] Community notified (if applicable)

## Monitoring After Release

After release, monitor:

- Community feedback and bug reports
- GitHub issues/discussions
- Script hub comments
- Performance reports
- Compatibility issues

## Updating to New Version

### For Users

To update when new version released:

```lua
-- Unload old version
-- Execute new uranium-hub.lua
loadstring(game:HttpGet("https://your-domain/uranium-hub.lua"))()
```

### For Developers

To update source:

```bash
git fetch origin
git pull origin main
-- Update version-specific code if needed
```

## Maintenance

### Regular Tasks

- Monitor for Roblox API changes
- Update dependencies (Obsidian UI)
- Review and merge community contributions
- Test with new Roblox updates
- Keep documentation current

### Deprecation

When removing features:

1. Mark as deprecated in documentation
2. Show warning in console
3. Keep working for one major version
4. Remove in next major version
5. Update migration guide

---

**Uranium Hub v1.0** | Build & Deployment Guide
