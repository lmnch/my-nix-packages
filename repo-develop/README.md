# repo-develop

Fuzzily select a Git repository and run `nix develop` there in the current
terminal.

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

Install it into your user profile with:

```console
nix profile add path:./repo-develop
```
