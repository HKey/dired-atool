# dired-atool

[![Build Status](https://travis-ci.org/HKey/dired-atool.svg?branch=master)](https://travis-ci.org/HKey/dired-atool)

Dired-atool is an utility to pack/unpack files with [atool](http://www.nongnu.org/atool/) on dired.

## Installation

TODO

## Setup key bindings

Call `dired-atool-setup` in your init.el like below:

```emacs-lisp
(dired-atool-setup)
```

or `M-x dired-atool-setup`.
`dired-atool-setup` sets key bindings of `dired-mode-map` below:

| key | command                 |
|-----|-------------------------|
| z   | `dired-atool-do-unpack` |
| Z   | `dired-atool-do-pack`   |

You can also set key bindings manually like below:

```emacs-lisp
(require 'dired)

(define-key dired-mode-map "z" #'dired-atool-do-unpack)
(define-key dired-mode-map "Z" #'dired-atool-do-pack)
```

## Commands

### `dired-atool-do-unpack`

This unpacks file(s) selected/marked on dired.

### `dired-atool-do-unpack-with-subdirectory`

This is an unpacking command like `dired-atool-do-unpack`.
But this makes subdirectories in the current directory and unpacks
files into them.

### `dired-atool-do-pack`

This packs file(s) selected/marked on dired.
