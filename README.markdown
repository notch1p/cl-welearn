=> [Original](https://github.com/notch1p/welearn-oneclick)

# Cl-Welearn

## Usage

Tested with SBCL in macOS and Linux. In Windows WINHTTP is used so it might be a bit different.

Basic usage is similar to the original repo, but cookie login is deprecated.
It now reads `WELEARN_ACCOUNT` and `WELEARN_PASSWORD`. The envs has a lower priority then cli args.

## Building

[ASDF](https://asdf.common-lisp.dev/), [Quicklisp](https://www.quicklisp.org/) AND [Ultralisp](https://ultralisp.org/) are needed for building.

- `make run` to run directly
- `make build` to build an uncompressed build in `bin/`.
- `make deploy` to deploy an compressed build in
- `make qlot-deploy` use package manger fukamachi/qlot to build.

> [!NOTE]
> Qlot install an additional copy of quicklisp and the dependencies used in the project folder.
