=> [Original](https://github.com/notch1p/welearn-oneclick)

> [!IMPORTANT]
> ![fkEnglish](https://flexio.blob.core.windows.net/notch1p/1__XEK5hMqdyjVw0GzQu-KUw.png)

# Cl-Welearn

## Usage

Tested with SBCL in macOS and Linux, uses Bordeaux-Threads. It should work with most implementations. In Windows WINHTTP is used so it might be a bit different.

Basic usage is similar to the original repo, but cookie login is deprecated.
It now reads `WELEARN_ACCOUNT` and `WELEARN_PASSWORD`. Envs have a lower priority than cli args.

## Building

[ASDF](https://asdf.common-lisp.dev/), [Quicklisp](https://www.quicklisp.org/) AND [Ultralisp](https://ultralisp.org/) are needed for building.

- `make run` to run directly
- `make build` to build an uncompressed binary in `bin/`.
- `make deploy` to deploy an compressed binary w/ verbose startup message.
- `make qlot-deploy` use package manger [fukamachi/qlot](https://github.com/fukamachi/qlot) to build, quicklisp and such are configured alonside then the same as `deploy`.This way only asdf is needed. Default target.

> [!NOTE]
> SBCL already comes with asdf. Qlot (works like npm) installs a local copy of quicklisp and the dependencies used in the project folder.
