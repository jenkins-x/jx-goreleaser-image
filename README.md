# README

We use goreleaser to build all jx binaries.
It's a bit tricky to change the go version in the goreleaser image (using the `gobinary` flag in .goreleaser.yaml file).
Upgrading the goreleaser image can bump the go version used to build the binaries unexpectedly.
Also there are extra packages like syft that we need when we build the binary to create the sbom.
Hence, this repo creates a goreleaser image where we can modify the go version when we want to, and also installs any extra packages we want to use with goreleaser (syft and cosign)
