# counsel-ghq.el [![melpa badge][melpa-badge]][melpa-link] [![melpa stable badge][melpa-stable-badge]][melpa-stable-link]

## Introduction

`counsel-ghq.el` provides interfaces of [ghq](https://github.com/motemen/ghq) with [ivy](https://github.com/abo-abo/swiper).

`counsel-ghq.el` is inspired by [helm-ghq.el](https://github.com/masutaka/emacs-helm-ghq).

## Requirements

* [ivy](https://github.com/abo-abo/swiper) 0.9.1 or higher
* [ghq](https://github.com/motemen/ghq) 0.7.4 or higher

## Installation

You can install `counsel-ghq.el` from [MELPA](https://github.com/milkypostman/melpa.git) with package.el (`M-x package-install counsel-ghq`)

## Usage

### `counsel-ghq`

Execute with `ghq list --full-path` command. You can select
a directory from the results.

You can select further action pressing `M-o` by default.

[melpa-link]: http://melpa.org/#/counsel-ghq
[melpa-stable-link]: http://stable.melpa.org/#/counsel-ghq
[melpa-badge]: http://melpa.org/packages/counsel-ghq-badge.svg
[melpa-stable-badge]: http://stable.melpa.org/packages/counsel-ghq-badge.svg
