# git-complete-company

is a git-complete backend for company.

See `git-complete` repository for completion algorithm details.

## Usage

This package provides two company-backends:

- `git-complete-company-whole-line-backend`

  company-backend which performs completion with "whole current-line
  completion" algorithm implemented in `git-complete`.

- `git-complete-company-omni-backend`

  company-backend which performs completion with either "omni
  current-line completion" or "omni next-line completion" algorithm
  implemented in `git-complete`.

To enable these backends, add them to `company-backends` list.

```emacs-lisp
(setq company-backends
      '(git-complete-company-omni-backend
        git-complete-company-whole-line-backend
        ...))
```

Note that these backends are much slower than other backends to
collect and filter completion candidates. So they are (by default)
configured not to start automatically. When (and only when) you invoke
company explicitly (with `company-complete` or similar commands),
these backends start to work.

This behavior can be changed by setting
`git-complete-company-manual-only` `nil`, but it's not recommended.

## Limitations

Unlike the original `git-complete` command, `git-complete-company` is
implemented as two different backends. So they cannot be used at the
same time (i.e. when "whole-line" backend finds some candidates,
"omni" backend does not work at all). You can still choose which
backend will take precedence by changing the order of
`company-backends`, but `git-complete-company` perhaps is not as
useful as the original command.

A good news is: I'm currently working on another omni completion
backend called `company-symbol-after-symbol`, which is fast enough and
comes with auto-start feature. So it may be a good idea to use it for
omni completion (instead of `git-complete-company-omni-backend`), and
use `git-complete-company` just for "whole-line" completion.

```emacs-lisp
(setq company-backends
      '(git-complete-company-whole-line-backend
        company-symbol-after-symbol
        ...))
```
