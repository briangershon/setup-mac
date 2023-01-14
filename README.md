# setup-mac

My personal configuration for MacOS machines.

## Setup MacOS Machine

Update Computer name via `System Preferences > Sharing`.

Install Desktop apps:

- Install 1Password.
- Install Brave Browser. Setup various profiles.
- Dropbox
- Discord

In Mac App Store, install:

- Slack

## Setup Developer Tools

Install iTerm2.

Install Docker Desktop.

Switch macOS shell to bash: Open Terminal and then run `chsh -s /bin/bash` then restart Terminal.

Install Microsoft Visual Code extensions:

- `command-shift-p` and run `Shell Command: Install 'code' command in PATH`

- `Prettier - Code formatter` by Prettier

  - update Settings for `Editor: Default Formatter` to `Prettier - Code formatter`.

- `Dev Containers` by Microsoft

- `Solidity` by Nomic Foundation

- `Tailwind CSS` by Tailwind Labs

- `GitHub Codespaces` by GitHub

- `Docker` by Microsoft

Setup Passwordless Auth to Github via SSH

    ssh-keygen -t ed25519 -C "<desired email address here>"

    # legacy version
    ssh-keygen -t rsa -b 4096 -C "<desired email address here>"

    # add public key to Github

For nice visual Git diffs, there are many options:

- Use VSCode's tools
- Install `difftastic`, a Rust-based diff tool installed via Homebrew below. Run as `difft`.
- Install Github Desktop and the command line tool so you can run `github .` in any repository.

Install Homebrew

    xcode-select --install

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

If homebrew needs to be accessible for multiple user accounts on same machine: <https://medium.com/@leifhanack/homebrew-multi-user-setup-e10cb5849d59>

Install apps via Homebrew:

    brew install tmux git bash-completion gh difftastic gpg git-lfs

Install `nvm` to install NodeJS:

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

... and install latest version:

    nvm ls-remote
    nvm install v18
    nvm alias default v18

Install Go: https://github.com/briangershon/setup-go

## Clone setup-mac and link up config files

Clone this repo locally via `git clone git@github.com:briangershon/setup-mac.git`

Setup .dot config files

    # if files already exist merge/remove before linking

    cd ~
    ln -s ~/setup-mac/dotfiles/.gitconfig
    ln -s ~/setup-mac/dotfiles/.bash_profile
    ln -s ~/setup-mac/dotfiles/.tmux.conf

    rm ~/.profile

Also for `tmux` change MacOS keyboard shortcut so that CAPS LOCK maps to CTRL in "System Preferences > Keyboard" then "Modifier Keys..." button. This gives you the very nice `CAPSLOCK-a` (already setup in `.tmux.conf` instead of default `CTRL-b`.

## Additional Configuration

### Git configuration

Import your public/secret key for signing GitHub commits.

```bash
gpg --import ~/public-key.gpg
gpg --allow-secret-key-import --import ~/secret-key.gpg
gpg --list-keys
```

For first-time setup, generate brand new keypair with `gpg`: https://gist.github.com/Beneboe/3183a8a9eb53439dbee07c90b344c77e
