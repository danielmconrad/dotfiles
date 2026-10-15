# dotfiles

My macOS and Ubuntu setup, managed with [chezmoi](https://www.chezmoi.io). One command takes a fresh machine to a fully configured one: shell, apps, settings, SSH key, and GitHub access.

## Installation

Run whichever of these your system has (macOS usually ships `curl`, Ubuntu usually ships `wget`):

```sh
# macOS
sh -c "$(curl -fsSL https://raw.githubusercontent.com/danielmconrad/dotfiles/main/.install/install.sh)"

# Ubuntu
sh -c "$(wget -qO- https://raw.githubusercontent.com/danielmconrad/dotfiles/main/.install/install.sh)"
```

Expect a few prompts along the way: your password, your email address, an SSH key passphrase, and a browser login to GitHub.

## How it works

```
install.sh ──▶ chezmoi init ──▶ dcli hook ──▶ run_once scripts ──▶ dotfiles
```

1. **Bootstrap.** [`.install/install.sh`](.install/install.sh) asks for your password up front, waits for the Xcode Command Line Tools on macOS, then installs chezmoi and hands off to `chezmoi init --apply danielmconrad`.
2. **Config.** chezmoi clones this repo into `~/.local/share/chezmoi` and renders [`.chezmoi.toml.tmpl`](.chezmoi.toml.tmpl) into `~/.config/chezmoi/chezmoi.toml`. This is where it asks for your email, once per machine.
3. **Dashlane CLI.** Before chezmoi reads anything else, a hook runs [`.install/dcli.sh`](.install/dcli.sh), which downloads `dcli` into `~/.local/bin`. This is what lets templates pull secrets from Dashlane. On later runs it exits immediately.
4. **Scripts.** Everything in [`.chezmoiscripts/`](.chezmoiscripts) runs in numeric order. Each is a `run_once_` script, so it runs again only when its contents change.
5. **Dotfiles.** The `dot_*.tmpl` files are rendered into your home directory as `~/.aliases`, `~/.env`, `~/.zprofile` and `~/.zshrc`.

### The scripts

| Range | What happens |
|---|---|
| `000`–`004` | SSH key, OS defaults, Homebrew, core tools, GitHub CLI and SSH key upload |
| `010`–`018` | Git, zsh with oh-my-zsh, Starship, iTerm2, Rectangle, Docker, browsers, VPN, mise |
| `019`–`032` | Apps: AppCleaner, Spotify, VS Code, Slack, Postman, BetterMouse and more |
| `200` | Cleanup |

### SSH keys

Every machine gets its own key, rather than sharing one, so a lost laptop can be revoked without touching the others. [`000_ssh`](.chezmoiscripts/run_once_000_ssh.sh.tmpl) creates the key if none exists, and [`004_github`](.chezmoiscripts/run_once_004_github.sh.tmpl) logs in with `gh` and uploads it. Both label the key so it's easy to recognize on GitHub:

```
daniel.conrad@JXGF6YK2F5 · MacBook Pro · macOS 26.6.2 arm64 · 2026-10-15
```

## Repository layout

| Path | Purpose |
|---|---|
| `dot_*.tmpl` | Dotfiles chezmoi writes to `~` |
| `.chezmoiscripts/` | Install scripts, run in numeric order |
| `.chezmoi.toml.tmpl` | Per-machine config: email prompt and Dashlane hook |
| `.config/` | App settings the scripts copy into place: iTerm2, Rectangle, BetterMouse, GNOME Terminal |
| `.install/` | Bootstrap script, Dashlane hook, and shared shell helpers |

chezmoi ignores everything whose name starts with `.`, apart from its own `.chezmoi*` files, so `.config/` and `.install/` never end up in your home directory.

## Everyday use

```sh
chezmoi update           # pull the latest changes and apply them
chezmoi diff             # preview what would change
chezmoi edit ~/.zshrc    # edit a dotfile's source
```

**Adding an app:** copy one of the app scripts, give it the next free number, and change the `install_brew_cask` line.

**Updating app settings:** export the app's current preferences into `.config/`. The matching script copies them into place on the next install.

**Using a secret:** reference it from any template with chezmoi's [Dashlane functions](https://www.chezmoi.io/user-guide/password-managers/dashlane/), for example `{{ (index (dashlanePassword "github") 0).password }}`. The value is filled in on the machine and never committed.
