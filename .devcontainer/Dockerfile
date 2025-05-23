# https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/base/tags
FROM mcr.microsoft.com/devcontainers/base:1.0.21-bookworm@sha256:eb406d55b2ecd2f8a31d23e4bee50af112d688d169da7457f436f5825c3cef12

USER root

ARG ANDROID_STUDIO_VERSION \
    ATAK_VERSION

ENV ANDROID_STUDIO_URL="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/${ANDROID_STUDIO_VERSION}/android-studio-${ANDROID_STUDIO_VERSION}-linux.tar.gz" \
    ANDROID_STUDIO_HOME=/opt/android-studio
ENV PATH="$ANDROID_STUDIO_HOME/bin:$PATH"

COPY "files/ATAK-CIV-${ATAK_VERSION}-SDK.zip" "/tmp/ATAK-CIV-SDK.zip"

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

RUN <<EOF
curl -L -o android-studio.tar.gz ${ANDROID_STUDIO_URL}
tar -xzf android-studio.tar.gz -C /opt
mv /opt/android-studio /opt/android-studio-${ANDROID_STUDIO_VERSION}
ln -s /opt/android-studio-${ANDROID_STUDIO_VERSION} ${ANDROID_STUDIO_HOME}
rm android-studio.tar.gz

EOF

USER vscode

HEALTHCHECK NONE
