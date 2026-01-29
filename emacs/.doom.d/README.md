# Doom Emacs Configuration

## Setup

### Installation

1. Symlink this directory to `~/.config/doom`:
   ```bash
   ln -s ~/path/to/dotfiles/emacs/.doom.d ~/.config/doom
   ```

2. Run Doom sync:
   ```bash
   doom sync
   ```

### Nerd Icons Setup (Required for Terminal Emacs)

The configuration uses Berkeley Mono as the primary font. To get icons working in **terminal Emacs** (e.g., iTerm2), you need to configure a non-ASCII font for icon glyphs.

1. Install Symbols Nerd Font:
   ```bash
   brew install font-symbols-only-nerd-font
   ```

2. In Emacs, install the nerd-icons fonts:
   ```
   M-x nerd-icons-install-fonts
   ```

3. Configure iTerm2 (or your terminal emulator):
   - Go to **iTerm2 → Preferences → Profiles → Text**
   - Under "Font", keep **Berkeley Mono** as your main font
   - Check the box **"Use a different font for non-ASCII text"**
   - Click "Non-ASCII Font" and select **"SymbolsNerdFontMono-Regular"** (size 12)
   - Restart your terminal

**Why is this needed?** Terminal emulators (not Emacs) handle font rendering. They need a separate font configured for non-ASCII characters (icons/symbols) because Berkeley Mono doesn't include these glyphs. GUI Emacs handles this automatically via font fallback, but terminal Emacs relies on the terminal's font configuration.

### Doom Doctor

After setup, run `doom doctor` to check for any issues:
```bash
doom doctor
```
