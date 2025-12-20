# https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/base/tags
FROM mcr.microsoft.com/devcontainers/base:2.1.3-bookworm@sha256:1d5ccf8d7fe290a16617e55a2f10dcf7856c765d4894bf6e9cf54ec0491a4a7f AS android-setup

ARG ANDROID_STUDIO_VERSION

ENV ANDROID_STUDIO_URL="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/${ANDROID_STUDIO_VERSION}/android-studio-${ANDROID_STUDIO_VERSION}-linux.tar.gz"

RUN <<EOF
export DEBIAN_FRONTEND=noninteractive && apt-get update 
apt-get upgrade -y
apt-get -y install --no-install-recommends \
ca-certificates coreutils curl
EOF

RUN <<EOF
curl -L -o android-studio.tar.gz ${ANDROID_STUDIO_URL}
tar -xzf android-studio.tar.gz -C /opt
rm android-studio.tar.gz
EOF

# https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/base/tags
FROM mcr.microsoft.com/devcontainers/base:2.1.3-bookworm@sha256:1d5ccf8d7fe290a16617e55a2f10dcf7856c765d4894bf6e9cf54ec0491a4a7f

USER root

ENV PATH="/opt/android-studio/bin:$PATH"

COPY --from=android-setup /opt/android-studio /opt/android-studio

RUN <<EOF
export DEBIAN_FRONTEND=noninteractive && apt-get update 
apt-get upgrade -y
apt-get -y install --no-install-recommends \
ca-certificates coreutils curl git gnupg2 gpg wget zip \
apt-transport-https
wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
apt-get update
apt-get -y install temurin-11-jdk
apt-get clean 
rm -rf /var/lib/apt/lists/* 
rm -rf /var/cache/apt/archives/partial/*
EOF

USER vscode

HEALTHCHECK NONE
