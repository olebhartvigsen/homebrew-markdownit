# Homebrew tap for MarkDownIt

A native markdown viewer and editor for macOS and Windows, built with the
platform's own text and drawing stack. This tap installs the macOS app from
source on your Mac.

## Install

```sh
brew install olebhartvigsen/markdownit/markdownit
ln -sfn "$(brew --prefix)/opt/markdownit/MarkDownIt.app" /Applications/MarkDownIt.app
```

The formula prints the second command when it finishes; Homebrew does not
write to `/Applications` on its own.

Since Homebrew 6, non-official taps need explicit trust. The fully qualified
name above grants trust for this one formula as part of the install. If you tap
first and then install by the short name, grant it yourself:

```sh
brew tap olebhartvigsen/markdownit
brew trust --formula olebhartvigsen/markdownit/markdownit
brew install markdownit
```

## Why a tap and not homebrew/cask

Two reasons, both unavoidable for now:

- The app is signed ad hoc and is not notarized, so a prebuilt download would
  be blocked by Gatekeeper on first launch. Homebrew applies the quarantine
  flag to cask downloads and no longer offers a flag to bypass it.
- `homebrew/cask` requires a Gatekeeper-clean download and a notability
  threshold a new project does not meet yet.

A formula builds on your machine, so there is no downloaded binary for
Gatekeeper to assess and no Apple Developer account involved.

## Upgrade, remove

```sh
brew upgrade markdownit    # rebuilds from the pinned source
brew uninstall markdownit  # removes the app, keeps your settings
rm -rf ~/Library/Application\ Support/MarkDownIt ~/Library/Logs/MarkDownIt
```

## Moving the formula forward

The formula currently pins a commit, because the v0.2.1 tag predates the macOS
port. When a tag exists that carries it, replace `url` with the tag archive,
drop the explicit `version`, and update `sha256`:

```sh
curl -sSL https://github.com/olebhartvigsen/MarkDownIt/archive/refs/tags/v0.2.2.tar.gz | shasum -a 256
```

`brew install --HEAD olebhartvigsen/markdownit/markdownit` builds the current
`main` branch instead, which is the quickest way to test a change before a tag.

## Licensing

MarkDownIt is MIT licensed. The formula is offered under the same terms; it is
not affiliated with the Homebrew project.
