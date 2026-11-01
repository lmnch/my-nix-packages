# sway-run-floating

Open a new floating Alacritty window under Sway and execute a command in it.

Pass the command and each of its arguments after `--`:

```console
nix run path:./sway-run-floating -- htop
nix run path:./sway-run-floating -- bash -lc 'printf "Hello\\n"; read'
```

Install it into your user profile with:

```console
nix profile add path:./sway-run-floating
sway-run-floating htop
```

The command must be run from inside a Sway session. Its arguments are passed
directly to Alacritty without shell evaluation. The launcher waits for the
window to close and exits with the command's exit status, including cancellation
statuses returned by interactive tools such as `fzf`. It also emits the
command's standard output, so a selected value can be captured normally:

```console
selected_file=$(sway-run-floating fzf)
```

Standard error stays attached to the floating terminal so interactive programs
can render their interface and diagnostics there.
