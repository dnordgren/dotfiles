# dotfiles
various configs for various softwares :computer:

## Setup

### Homebrew Packages

Install all packages from the Brewfile:
```bash
cd ~/path/to/dotfiles
brew bundle install
```

To update the Brewfile with your current packages:
```bash
cd ~/path/to/dotfiles
brew bundle dump --force
```

### GPG Setup for Git Commit Signing

After installing `gnupg` and `pinentry-mac` from the Brewfile, configure GPG:

1. Fix GPG directory permissions:
   ```bash
   chmod 700 ~/.gnupg
   ```

2. Configure GPG to use pinentry-mac for passphrase prompts:
   ```bash
   echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf
   gpgconf --kill gpg-agent
   ```

3. Verify GPG signing works:
   ```bash
   echo "test" | gpg --clearsign
   ```
   You should be prompted for your passphrase.

### Zsh Configuration

1. Symlink the zsh config:
   ```bash
   ln -s ~/path/to/dotfiles/zsh/.zshrc ~/.zshrc
   ```

2. Install oh-my-zsh (if not already installed):
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

3. **Important:** For hstr + fzf C-r search to work, you need to have `~/.fzf.zsh` available. If you're migrating to a new machine, copy your existing `~/.fzf.zsh` file or generate it by reinstalling fzf:
   ```bash
   brew reinstall fzf
   /opt/homebrew/opt/fzf/install
   ```

4. Reload your shell:
   ```bash
   source ~/.zshrc
   ```

### Doom Emacs Configuration

See [emacs/.doom.d/README.md](emacs/.doom.d/README.md) for Doom Emacs setup instructions.

### BBEdit Command Line Tools

After installing BBEdit, install the command line tools to enable the `bbedit` command:

1. Open BBEdit
2. Go to **BBEdit → Install Command Line Tools...**
3. Click Install

This installs the `bbedit` command to `/usr/local/bin/bbedit` and is required for:
- Using BBEdit as your `$EDITOR`
- The `bb` alias in `.zshrc`
- Claude Code's C-g editor integration
