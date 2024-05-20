FROM golang:1.22.3-alpine3.19@sha256:f1fe698725f6ed14eb944dc587591f134632ed47fc0732ec27c7642adbe90618

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
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin v1.4.1 &&\
    chmod +x /usr/local/bin/syft &&\
    syft --version

# Install cosign
COPY --from=gcr.io/projectsigstore/cosign:v2.2.4@sha256:bed7ba33a8610c1607c16dee696f62bad168814016126abb9da01e9fb7cb2167 /ko-app/cosign /usr/local/bin/cosign
RUN cosign version

# Install goreleaser
RUN curl -L https://github.com/goreleaser/goreleaser/releases/download/v1.26.1/goreleaser_Linux_x86_64.tar.gz | tar xzv &&\
    rm -rf README.md completions manpages &&\
    mv goreleaser /usr/local/bin &&\
    goreleaser -v
