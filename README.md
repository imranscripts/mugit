<p align="center">
  <img src="logo.png" alt="mugit" width="200"/>
</p>

<p align="center">
  Every branch. One cup. Extra cinnamon.
</p>

---

## What it does

`mugit` lets you run any git command across all your repositories at once. Register root folders containing your repos, then use `mugit` exactly like you'd use `git`.

```
mugit pull --rebase        # pull every repo
mugit status               # status across all repos
mugit checkout -b feature  # new branch everywhere
```

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/imranscripts/mugit/main/install.sh | bash
```

The installer handles everything — no dependencies beyond `bash` and `git`.

> Installs to `~/.local/bin`, adds it to your PATH in your shell config, and prompts you to reload if needed.

To uninstall:

```bash
curl -fsSL https://raw.githubusercontent.com/imranscripts/mugit/main/uninstall.sh | bash
```

---

## Setup

Register the folders that contain your repos:

```bash
mugit config --add ~/work
mugit config --add ~/personal ~/oss
```

`mugit` walks up to 5 directories deep to find `.git` folders, stopping descent as soon as a repo is found (so nested repos aren't double-counted). A folder that is itself a repo is also supported. Override the depth with `MUGIT_DEPTH`:

```bash
mugit config --list    # see registered roots and discovered repos
mugit config --rm ~/work
mugit config --clean   # remove all roots
```

```bash
MUGIT_DEPTH=8 mugit config --list   # scan deeper if needed
```

---

## Usage

```
mugit [mugit-options] <git-command> [git-args...]
```

### Mugit options

| Flag | Short | Description |
|---|---|---|
| `--only repo1,repo2` | `-o` | Limit to repos whose name contains any of the given strings |
| `--except repo1,repo2` | `-x` | Exclude repos whose name contains any of the given strings |
| `--dry-run` | `-n` | Print commands without executing them |
| `--yes` | `-y` | Skip safety confirmation (for scripts and CI) |
| `--version` | `-V` | Print version and exit |

### Examples

```bash
# Run across every registered repo
mugit fetch --all
mugit commit -m "chore: bump version"
mugit push

# Target specific repos
mugit --only api,frontend pull --rebase
mugit -o shared checkout main

# Exclude repos
mugit --except legacy,archived status
mugit -x archived push

# Preview before running
mugit --dry-run reset --hard HEAD
mugit -n push origin main
```

---

## Safety confirmations

Destructive git operations require you to type `yes` before mugit runs them across your repos. A typo won't cut it — only the full word proceeds.

```
⚠  DANGEROUS OPERATION
  Matched pattern: push --force
  This will run across 6 repo(s).
  Use --dry-run / -n to preview first.

  Type yes to continue, anything else aborts:
```

**Commands that trigger a confirmation:**

| Command | Flags |
|---|---|
| `push` | `--force`, `-f`, `--force-with-lease`, `--mirror`, `--delete` |
| `reset` | `--hard` |
| `clean` | `-f`, `-fd`, `-df`, and other combined short flags |
| `branch` | `-D` |
| `checkout` | `--force`, `-f` |

Running with `--dry-run` skips the confirmation — previewing is always safe.

In non-interactive shells (scripts, CI), mugit errors immediately if a dangerous command is used without `--yes`:

```
error: dangerous operation 'push --force' in non-interactive shell — pass --yes to confirm
```

---

## Shell completions

```bash
# bash — add to ~/.bashrc or ~/.bash_profile
eval "$(mugit completions bash)"

# zsh — add to ~/.zshrc
eval "$(mugit completions zsh)"

# zsh (persistent, via Homebrew prefix)
mugit completions zsh > $(brew --prefix)/share/zsh/site-functions/_mugit
```

---

## Environment

| Variable | Default | Description |
|---|---|---|
| `MUGIT_DEPTH` | `5` | Max directory depth when scanning for repos |
| `NO_COLOR` | — | Set to any value to disable colored output |

---

## Output

Each repo gets a header, then the raw git output beneath it:

```
━━━ api (~/work/api)
Already up to date.

━━━ frontend (~/work/frontend)
Updating abc1234..def5678
Fast-forward
 src/index.js | 2 +-

━━━ shared (~/work/shared)
Already up to date.
```

If any repo fails, mugit reports them all at the end and exits with a non-zero status.

```
━━━ frontend (~/work/frontend)
failed

failed: frontend
```

---

## Config file

Roots are stored in `~/.config/mugit/roots`, one path per line. You can edit it directly if you prefer.

---

## Contributing

Contributions are welcome — bug fixes, new safety patterns, shell compatibility improvements, and new flags. See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## License

MIT
