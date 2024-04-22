=> [Original](https://github.com/notch1p/welearn-oneclick)

> [!IMPORTANT]
> ![fkEnglish](https://flexio.blob.core.windows.net/notch1p/1__XEK5hMqdyjVw0GzQu-KUw.png)

# Cl-Welearn

## Usage

Tested with SBCL in macOS and Linux, uses Bordeaux-Threads. In Windows WINHTTP is used so it might be a bit different.

Basic usage is similar to the original repo, but cookie login is deprecated.
It now reads `WELEARN_ACCOUNT` and `WELEARN_PASSWORD`. The env has a lower priority then cli args.

## Building

[ASDF](https://asdf.common-lisp.dev/), [Quicklisp](https://www.quicklisp.org/) AND [Ultralisp](https://ultralisp.org/) are needed for building.

- `make run` to run directly
- `make build` to build an uncompressed build in `bin/`.
- `make deploy` to deploy an compressed build in
- `make qlot-deploy` use package manger fukamachi/qlot to build. Only asdf is needed.

> [!NOTE]
> SBCL already comes with asdf and Qlot (works like npm) install an local copy of quicklisp and the dependencies used in the project folder.
