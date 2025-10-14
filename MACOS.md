# macOS Configuration Guide

This document explains how to manage macOS system preferences via the `defaults` command in your dotfiles.

## Configuration File

**Location:** `run_onchange_before_configure-macos.sh.tmpl`

This script automatically applies when:
- You run `chezmoi apply`
- The script file is modified
- You run it manually: `~/.local/share/chezmoi/run_onchange_before_configure-macos.sh`

## Categories Configured

### 1. General UI/UX
- Disables "Are you sure you want to open?" dialogs
- Disables auto-capitalization, smart quotes, auto-correct
- Enables full keyboard navigation

### 2. Keyboard & Input
- **Fast key repeat** - Essential for developers (1 = 15ms)
- **Short initial delay** - Faster repeat start (10 = 150ms)
- Disables press-and-hold (enables key repeat in all apps)

### 3. Trackpad & Mouse
- Tap to click enabled
- Three-finger drag enabled
- Faster tracking speed

### 4. Screen & Display
- Screenshots → Downloads folder (not Desktop)
- Screenshots in PNG format without shadows
- Password required immediately after sleep

### 5. Finder
- Show all file extensions
- Show hidden files
- Show path bar and status bar
- List view by default
- No .DS_Store on network/USB drives
- ~/Library folder visible

### 6. Dock
- 48px icons (64px when magnified)
- Auto-hide with no delay
- No recent apps
- Indicator lights for running apps
- Hot corners configured

### 7. Safari & WebKit
- Full URLs in address bar
- Developer tools enabled
- Do Not Track enabled
- No search suggestions sent to Apple

### 8. Terminal
- UTF-8 encoding
- Secure keyboard entry

### 9. Other Apps
- Activity Monitor: CPU usage view
- TextEdit: Plain text mode
- Photos: Don't auto-open
- App Store: Auto-updates enabled

## Discovering Current Settings

### Find what domain an app uses:
```bash
# List all domains
defaults domains | tr ',' '\n' | sort

# Common domains:
# - NSGlobalDomain (system-wide settings)
# - com.apple.dock
# - com.apple.finder
# - com.apple.Safari
# - com.apple.screencapture
# - com.apple.Terminal
```

### Read current settings:
```bash
# Read all settings for an app
defaults read com.apple.dock

# Read a specific setting
defaults read com.apple.dock autohide

# Read with data type
defaults read-type com.apple.dock autohide
```

### Find what changed after GUI adjustment:
```bash
# 1. Save current state
defaults read > before.txt

# 2. Change setting in System Preferences
# 3. Save new state
defaults read > after.txt

# 4. Compare
diff before.txt after.txt
```

### Better approach - watch specific domain:
```bash
# Before changing setting:
defaults read com.apple.dock > dock-before.txt

# Change Dock setting in System Preferences
# After changing:
defaults read com.apple.dock > dock-after.txt
diff dock-before.txt dock-after.txt
```

## Customizing Settings

### Option 1: Edit the script directly
```bash
chezmoi edit ~/.local/share/chezmoi/run_onchange_before_configure-macos.sh.tmpl
```

### Option 2: Override in .zshrc.local
```bash
# ~/.zshrc.local (not tracked by chezmoi)
# This runs after dotfiles are applied

# Example: Revert key repeat to slower speed
defaults write NSGlobalDomain KeyRepeat -int 2
```

### Option 3: Create local override script
```bash
# ~/bin/macos-overrides.sh (not tracked)
#!/usr/bin/env bash

# Personal overrides to dotfile defaults
defaults write com.apple.dock autohide -bool false
killall Dock
```

## Common Settings Reference

### Keyboard
```bash
# Key repeat rate (lower = faster, min: 1)
defaults write NSGlobalDomain KeyRepeat -int 1

# Initial delay (lower = faster, min: 10)
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Disable press-and-hold
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
```

### Dock
```bash
# Icon size (16-128)
defaults write com.apple.dock tilesize -int 48

# Auto-hide
defaults write com.apple.dock autohide -bool true

# Auto-hide delay (0 = instant)
defaults write com.apple.dock autohide-delay -float 0

# Position (left, bottom, right)
defaults write com.apple.dock orientation -string "bottom"

# Minimize effect (genie, scale, suck)
defaults write com.apple.dock mineffect -string "scale"
```

### Finder
```bash
# Default view (icnv=icon, clmv=column, glyv=gallery, Nlsv=list)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# New Finder window location (PfHm = Home, PfDe = Desktop)
defaults write com.apple.finder NewWindowTarget -string "PfHm"
```

### Screenshots
```bash
# Save location
defaults write com.apple.screencapture location -string "${HOME}/Downloads"

# Format (png, jpg, gif, pdf, tiff, bmp)
defaults write com.apple.screencapture type -string "png"

# Disable shadow
defaults write com.apple.screencapture disable-shadow -bool true

# Include date in filename
defaults write com.apple.screencapture include-date -bool true
```

### Mission Control
```bash
# Don't rearrange spaces
defaults write com.apple.dock mru-spaces -bool false

# Animation speed (lower = faster)
defaults write com.apple.dock expose-animation-duration -float 0.1

# Group windows by application
defaults write com.apple.dock expose-group-apps -bool true
```

### Menu Bar
```bash
# Show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Flash time separators (: blinks in clock)
defaults write com.apple.menuextra.clock FlashDateSeparators -bool false

# 24-hour time
defaults write com.apple.menuextra.clock Show24Hour -bool true
```

## Testing Changes

### Test without applying:
```bash
# Read current value
defaults read com.apple.dock autohide

# Try new value in current session
defaults write com.apple.dock autohide -bool true
killall Dock

# If you don't like it, revert
defaults delete com.apple.dock autohide
killall Dock
```

### Apply to dotfiles:
```bash
# Edit the script
chezmoi edit ~/.local/share/chezmoi/run_onchange_before_configure-macos.sh.tmpl

# Apply changes
chezmoi apply
```

## Reverting Settings

### Revert specific setting:
```bash
# Delete the key (reverts to system default)
defaults delete com.apple.dock autohide
killall Dock
```

### Revert entire domain:
```bash
# ⚠️ CAUTION: This resets ALL settings for the app
defaults delete com.apple.dock
killall Dock
```

### Revert to macOS defaults:
```bash
# Remove customizations and use system defaults
rm ~/.local/share/chezmoi/run_onchange_before_configure-macos.sh.tmpl
chezmoi apply

# Then manually revert in System Preferences
```

## Useful Commands

### List all defaults for an app:
```bash
defaults read com.apple.dock
```

### Find defaults for current frontmost app:
```bash
osascript -e 'id of app "System Events"' -e 'tell application "System Events" to get bundle identifier of first process whose frontmost is true'
```

### Export all settings:
```bash
defaults read > ~/Desktop/macos-defaults-backup.txt
```

### Search for a setting:
```bash
defaults read | grep -i "keyword"
defaults find "keyword"
```

## Hot Corners

Values for `wvous-{tl,tr,bl,br}-corner`:
- `0` - No action
- `2` - Mission Control
- `3` - Application windows
- `4` - Desktop
- `5` - Start screen saver
- `6` - Disable screen saver
- `7` - Dashboard
- `10` - Put display to sleep
- `11` - Launchpad
- `12` - Notification Center
- `13` - Lock Screen

Modifiers for `wvous-{tl,tr,bl,br}-modifier`:
- `0` - No modifier
- `131072` - Shift
- `262144` - Control
- `524288` - Option
- `1048576` - Command

Example - require Command key:
```bash
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 1048576
```

## Advanced: System-Level Settings

Some settings require `sudo` or SIP disabled:

### Disable Gatekeeper (not recommended):
```bash
sudo spctl --master-disable
```

### Disable SIP to modify system files:
```bash
# Boot into Recovery Mode (Cmd+R)
# Terminal → csrutil disable
# Reboot
```

### Show hidden system files:
```bash
sudo chflags nohidden /path/to/file
```

## Resources

- [defaults-write.com](https://www.defaults-write.com/) - Database of macOS defaults
- [macOS defaults](https://macos-defaults.com/) - Modern UI for defaults
- [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles/blob/main/.macos) - Comprehensive example

## Troubleshooting

### Setting not taking effect:
```bash
# 1. Kill the affected app
killall Dock  # or Finder, SystemUIServer, etc.

# 2. If that doesn't work, log out and back in

# 3. If still not working, restart
sudo shutdown -r now
```

### Check if setting was applied:
```bash
defaults read com.apple.dock autohide
# Should show: 1 (for true) or 0 (for false)
```

### Script not running:
```bash
# Check if script is executable
ls -la ~/.local/share/chezmoi/run_onchange_before_configure-macos.sh.tmpl

# Run manually to see errors
bash -x ~/.local/share/chezmoi/run_onchange_before_configure-macos.sh
```

## Safety

The provided defaults script:
- ✅ Only modifies user preferences (not system files)
- ✅ Does not require SIP disabled
- ✅ Can be reverted easily
- ✅ Does not delete any files
- ✅ Only runs on macOS (template check)

Always:
- Test settings individually before adding to dotfiles
- Keep a backup of working settings
- Document why you changed each setting
