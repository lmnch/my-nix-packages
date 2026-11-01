# repo-develop

Fuzzily select a Git repository, open it in a new terminal, and run
`nix develop` there.

By default, repositories are discovered directly below `~`. Set `REPO_ROOT`
to search elsewhere and `REPO_DEPTH` to search more deeply. A root passed as
the first argument takes precedence over `REPO_ROOT`:

```console
nix run path:./repo-develop -- ~/projects
REPO_ROOT=~/projects nix run path:./repo-develop
REPO_DEPTH=3 nix run path:./repo-develop
```

`REPO_DEPTH` defaults to `1`, meaning only repositories immediately inside the
root are included.

The script detects Kitty, Foot, WezTerm, Alacritty, GNOME Terminal, Konsole,
and XTerm. Set `TERMINAL` to override the detection:

```console
TERMINAL="kitty --single-instance" nix run path:./repo-develop
```

Install it into your user profile with:

```console
nix profile add path:./repo-develop
```
