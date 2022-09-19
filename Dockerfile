FROM ubuntu:22.04

RUN set -ex && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
  # These need no explanation
  curl \
  git \
  sudo \
  unzip \
  wget \
  # Use HTTPS for apt package download
  apt-transport-https \
  # Root certificates to trust for HTTPS connections
  ca-certificates \
  # Commit signing, Terraform binary signature verification
  gnupg2 \
  gpg-agent \
  dirmngr \
  # CLI JSON utility
  jq \
  # Shell script linter, also used by actionlint
  shellcheck \
  # For Git interaction with GitHub
  openssh-client \
  # Recursively list directories in tree format
  tree \
  # In case you want Vim
  vim \
  && \
  find /var/lib/apt/lists -delete -mindepth 1

# renovate: datasource=github-releases depName=rhysd/actionlint
ENV ACTIONLINT_VERSION=1.6.17
RUN set -ex && \
  wget -nv -P /tmp/ https://github.com/rhysd/actionlint/releases/download/v${ACTIONLINT_VERSION}/actionlint_${ACTIONLINT_VERSION}_linux_amd64.tar.gz && \
  tar -xzf /tmp/actionlint*.tar.gz && \
  rm /tmp/actionlint*.tar.gz && \
  chmod 755 actionlint && \
  mv actionlint /usr/local/bin
