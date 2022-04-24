# kubernetes-helpers

This is an zsh plugin to help with the usage and installation of multiple verions of common kubernetes tools, namely `clusterctl`, `kubectl` and `kind`.

## Usage

This plugin adds two functions for each of these tools, `*_download` and `*_switch`, to download and switch between versions.
Completion is rebuilt and cached after a version change.

## Configuration

This plugin supports configuration via `zstyle`.

### path

You can use `zstyle ':k8sctl:binaries' path $YOURPATH` to configure the path where binaries are downloaded and symlinked. Defaults to `$HOME/.local/bin`. This path should also be in your `$PATH`.

## Installation

I tested this only with `zinit`, but if it works with antigen, OMZ or zgen, please contact me and I will update this list.

### Zinit

Add `zinit load apoxa/k8sctl-helpers` to your zinit plugins in your `.zshrc`

## Notes

This is based on a [gist](https://gist.github.com/killianmuldoon/8e5d435bb0b1954bb96e967d93a3b9e8) from killianmuldoon. I made it zsh-compatible (without using `bashcompinit`) and fixed some minor bugs.
