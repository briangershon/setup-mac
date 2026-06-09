# setup-mac

My personal configuration for MacOS machines.

## Setup MacOS and Desktop Apps

Update Computer name via `System Preferences > Sharing`.

Install Desktop apps:

- Install 1Password
- Install Brave Browser and setup various profiles
- Dropbox
- Discord

In Mac App Store, install:

- Slack
- Telegram
- Coin Tick menubar app

## Setup Developer Tools

### Install Homebrew

```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

If homebrew needs to be accessible for multiple user accounts on same machine: <https://medium.com/@leifhanack/homebrew-multi-user-setup-e10cb5849d59>

Install apps via Homebrew:

```bash
brew install tmux git bash-completion gh gpg git-lfs starship hx neovim
```

### Shell and Terminal

1. Install latest bash

```bash
brew install bash
sudo sh -c 'echo /opt/homebrew/bin/bash >> /etc/shells'
chsh -s /opt/homebrew/bin/bash
bash --version   # should show 5.x
type mapfile     # should show "mapfile is a shell builtin"
```

2. Restart system.

3. Install ghostty terminal.

### Docker

Install Docker Desktop.

For Apple Silicon machines you may need one of these when working with non-ARM containers:
  - `export DOCKER_DEFAULT_PLATFORM=linux/amd64` to build containers on AMD/64 instead of default ARM/64.
  - `softwareupdate --install-rosetta` to run Intel containers


### Clone setup-mac and link up config files

Clone this repo locally via `git clone git@github.com:briangershon/setup-mac.git`

### Setup .dot config files

    # if files already exist merge/remove before linking

    cd ~
    ln -s ~/setup-mac/dotfiles/gitconfig .gitconfig
    ln -s ~/setup-mac/dotfiles/bash_profile .bash_profile
    ln -s ~/setup-mac/dotfiles/tmux.conf .tmux.conf
    ln -s ~/setup-mac/dotfiles/config/helix .config/helix
    ln -s ~/setup-mac/dotfiles/config/nvim .config/nvim
    ln -s ~/setup-mac/dotfiles/config/starship .config/starship

    rm ~/.profile

### tmux

Also for `tmux` change MacOS keyboard shortcut so that CAPS LOCK maps to CTRL in "System Preferences > Keyboard" then "Modifier Keys..." button. This gives you the very nice `CAPSLOCK-a` (already setup in `.tmux.conf` instead of default `CTRL-b`.

### Editor

Helix and NeoVim.

Why Helix? <https://phaazon.net/blog/more-hindsight-vim-helix-kakoune>

#### Helix Setup

For Helix, setup these dependencies:
- To support TypeScript LSP options: `npm i -g typescript typescript-language-server`

### Setup Git

Setup passwordless Auth to Github via SSH

```bash
ssh-keygen -t ed25519 -C "<desired email address here>"

# legacy version
ssh-keygen -t rsa -b 4096 -C "<desired email address here>"

 # add public key to Github
```

### Setup Node.js

Install `nvm` to install NodeJS:

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

... and install latest version:

    nvm ls-remote
    nvm install v18
    nvm alias default v18

### Install Go
https://github.com/briangershon/setup-go

## Additional Configuration

### Git configuration

Import your public/secret key for signing GitHub commits.

```bash
gpg --import ~/public-key.gpg
gpg --allow-secret-key-import --import ~/secret-key.gpg
gpg --list-keys
```

For first-time setup, generate brand new keypair with `gpg`: https://gist.github.com/Beneboe/3183a8a9eb53439dbee07c90b344c77e
