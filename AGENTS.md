# dotfiles

A chezmoi source directory. `README.md` explains how the setup works.

## Keep the README current

Whenever a change affects anything `README.md` describes, update the README in the same commit. That includes the install steps, the order things run in, the script number ranges, the repository layout, the SSH key behavior, the Dashlane setup, and the everyday commands.

## Things that aren't obvious

- **Dot-prefixed names are invisible to chezmoi** at the source root, except its own `.chezmoi*` files. That's why `.config/` and `.install/` never reach `~`. Any other new file at the root is copied into `~` unless it's listed in `.chezmoiignore`, which is how `README.md` and this file stay out.
- **Scripts must live in `.chezmoiscripts/`.** A `run_once_` script anywhere else either creates a folder in `~` or, inside a dot-prefixed folder, never runs.
- **`run_once_` scripts re-run whenever their rendered output changes.** Changing `.install/utilities.sh` re-runs every script on every machine, including the Homebrew and zsh setup, so avoid editing it. Put new helpers in their own file under `.install/`. Renaming or renumbering a script with the same output doesn't re-run it.
- **Templates render before any script runs.** Anything a template needs must already be installed, which is why `dcli` comes from the read-source-state hook (`.install/dcli.sh`) rather than a numbered script.
- **The repo is public.** Never commit secrets, license keys, or personal paths. Pull secrets from Dashlane in templates, and strip machine-specific state from files in `.config/` before committing.
- **Test changes without touching the real machine.** Render templates with `chezmoi --source . --config <test.toml> execute-template < file` and syntax-check the output with `sh -n`. A config without the `[hooks]` section keeps the dcli hook from running.
