# dired-atool

[![Build Status](https://travis-ci.org/HKey/dired-atool.svg?branch=master)](https://travis-ci.org/HKey/dired-atool)
[![MELPA](https://melpa.org/packages/dired-atool-badge.svg)](https://melpa.org/#/dired-atool)
[![MELPA Stable](https://stable.melpa.org/packages/dired-atool-badge.svg)](https://stable.melpa.org/#/dired-atool)

Dired-atool is an utility to pack/unpack files with [atool](http://www.nongnu.org/atool/) on dired.

## Requirements

- Emacs 24 or later

## Installation

You can install dired-atool from [MELPA](https://melpa.org/#/) or
[MELPA Stable](https://stable.melpa.org/#/) by following steps:

1. Setup the Emacs built-in package manager to use MELPA or MELPA Stable.  
   MELPA's documentation is [here](https://github.com/milkypostman/melpa#usage).

2. Install dired-atool.  
   `M-x package-install dired-atool`

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
## Versioning

The versioning of dired-atool follows [Semantic Versioning 2.0.0](http://semver.org/spec/v2.0.0.html).

## Commands

### `dired-atool-do-unpack`

This unpacks file(s) selected/marked on dired.

### `dired-atool-do-unpack-with-subdirectory`

This is an unpacking command like `dired-atool-do-unpack`.
But this makes subdirectories in the current directory and unpacks
files into them.

### `dired-atool-do-pack`

This packs file(s) selected/marked on dired.
