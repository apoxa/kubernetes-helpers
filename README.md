# k8sctl-helpers

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
