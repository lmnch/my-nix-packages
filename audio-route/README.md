# audio-route

An interactive PipeWire audio router. It uses `fzf` to select one or more
active playback streams and then the output sink to which they should move.

Run it directly from the flake:

```console
nix run path:/home/lmnch/audio-route
```

Install it into your user profile:

```console
nix profile add path:/home/lmnch/audio-route
```

List active streams and sinks without opening the picker:

```console
audio-route list
```

The package supplies `fzf`, `pactl`, `pw-cli`, `pw-link`, and the other runtime
commands through its wrapper, so they do not need to be installed separately.
