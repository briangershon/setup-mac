# setup-mac

My personal setup and configuration for a MacOS machine.

## Setup MacOS Machine

Update Computer name via `System Preferences > Sharing`.

Install Chrome and Firefox browsers. Login on each to sync bookmarks.

In Mac App Store, install Desktop apps:

- Slack
- 1Password
- Divvy

Install additional Desktop apps:

- Discord
- Dropbox

## Setup Developer Tools

Install iTerm2.

Install Docker.

Switch macOS shell to bash: Open Terminal and then run `chsh -s /bin/bash` then restart Terminal.

Install Microsoft Visual Code, and extensions:

- `Prettier - Code formatter` (by Esben Petersen) and then update these settings: Set `Editor: Default Formatter` to `esbenp.prettier-vscode`.

Setup Github SSH

    ssh-keygen -t ed25519 -C "<desired email address here>"

    # legacy version
    ssh-keygen -t rsa -b 4096 -C "<desired email address here>"

    # add public key to Github

Install Homebrew

    xcode-select --install

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

If homebrew needs to be accessible for multiple user accounts on same machine: <https://medium.com/@leifhanack/homebrew-multi-user-setup-e10cb5849d59>

Install apps via Homebrew:

    brew install pwgen tmux git bash-completion gh

Install `nvm`: https://github.com/creationix/nvm#install-script then latest NodeJS LTS

Install Go: https://github.com/briangershon/setup-go

## Configuration

Configure Git name and email (this now happens when dot files are symlinked below)

    git config --global user.name "Brian Gershon"
    git config --global user.email "briangershon@users.noreply.github.com"

For nice visual Git diffs, I like to use gitx (download from <http://rowanj.github.io/gitx/> and run "GitX > Enable Terminal Usage") and launch it from the commandline in whichever repo directory I'm in.

Clone this repo locally via `git clone git@github.com:briangershon/setup-mac.git`

Setup .dot config files

    cd ~
    ln -s ~/setup-mac/dotfiles/.bash_profile
    ln -s ~/setup-mac/dotfiles/.tmux.conf
    ln -s ~/setup-mac/dotfiles/.gitconfig

    # private repo for .ssh/config
