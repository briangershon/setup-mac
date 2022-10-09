# setup-mac

My personal configuration for MacOS machines.

## Setup MacOS Machine

Update Computer name via `System Preferences > Sharing`.

Install Brave Browser. Setup various profiles.

In Mac App Store, install Desktop apps:

- 1Password

Install additional Desktop apps:

- Dropbox
- Discord
- Slack

## Setup Developer Tools

Install iTerm2.

Install Docker.

Switch macOS shell to bash: Open Terminal and then run `chsh -s /bin/bash` then restart Terminal.

Install Microsoft Visual Code, and extensions/configure:

- `command-shift-p` and run `Shell Command: Install 'code' command in PATH`

- `Prettier - Code formatter` (by Esben Petersen) and then update these settings: Set `Editor: Default Formatter` to `esbenp.prettier-vscode`.

Setup Github SSH

    ssh-keygen -t ed25519 -C "<desired email address here>"

    # legacy version
    ssh-keygen -t rsa -b 4096 -C "<desired email address here>"

    # add public key to Github

For nice visual Git diffs, there are many options:

- Use VSCode's tools
- Use `difft`, a Rust-based diff tool installed via Homebrew (below)
- Install Github Desktop and the command line tool so you can run `github .` in any repository.

Install Homebrew

    xcode-select --install

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

If homebrew needs to be accessible for multiple user accounts on same machine: <https://medium.com/@leifhanack/homebrew-multi-user-setup-e10cb5849d59>

Install apps via Homebrew:

    brew install pwgen tmux git bash-completion gh difft

Install `nvm` to install NodeJS:

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

... and install latest version:

    nvm ls-remote
    nvm install v16
    nvm alias default v16

Install Go: https://github.com/briangershon/setup-go

## Clone setup-mac and link up config files

Clone this repo locally via `git clone git@github.com:briangershon/setup-mac.git`

Setup .dot config files

    # if files already exist merge/remove before linking

    cd ~
    ln -s ~/setup-mac/dotfiles/.gitconfig
    ln -s ~/setup-mac/dotfiles/.bash_profile
    ln -s ~/setup-mac/dotfiles/.tmux.conf

Also for `tmux` change MacOS keyboard shortcut so that CAPS LOCK maps to CTRL in "System Preferences > Keyboard" then "Modifier Keys..." button. This gives you the very nice `CAPSLOCK-a` (already setup in `.tmux.conf` instead of default `CTRL-b`.

## Additional Configuration

### Git configuration

Setup gpg for signed GitHub commits: https://gist.github.com/Beneboe/3183a8a9eb53439dbee07c90b344c77e

Import keys for signing key `C04296150767D5F0`
