FROM golang:1.19.3-alpine3.16@sha256:4e2a54594cfe7002a98c483c28f6f3a78e5c7f4010c355a8cf960292a3fdecfe

# Add image labels
LABEL org.opencontainers.image.title jx-goreleaser-image
LABEL org.opencontainers.image.description custom go releaser image for Jenkins X
LABEL org.opencontainers.image.vendor Jenkins X
LABEL com.docker.extension.publisher-url https://jenkins-x.io/

RUN apk add --no-cache bash \
    curl \
    git \
    make \
    build-base

# Install syft
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin v0.60.1 &&\
    chmod +x /usr/local/bin/syft &&\
    syft --version

# Install cosign
COPY --from=gcr.io/projectsigstore/cosign:v1.13.1@sha256:ac8e08a2141e093f4fd7d1d0b05448804eb3771b66574b13ad73e31b460af64d /ko-app/cosign /usr/local/bin/cosign
RUN cosign version

# Install goreleaser
RUN curl -L https://github.com/goreleaser/goreleaser/releases/download/v1.12.3/goreleaser_Linux_x86_64.tar.gz | tar xzv &&\
    rm -rf README.md completions manpages &&\
    mv goreleaser /usr/local/bin &&\
    goreleaser -v
