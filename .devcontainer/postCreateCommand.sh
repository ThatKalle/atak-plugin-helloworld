#!/bin/bash
set -e

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --android-studio-version) 
            ANDROID_STUDIO_VERSION="$2"
            shift
            ;;
        --basename) 
            BASENAME="$2"
            shift
            ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

unzip -q /tmp/ATAK-CIV-SDK.zip -d /tmp
sudo cp -r /tmp/ATAK-CIV*-SDK/* /workspaces
sudo rm -rf /tmp/ATAK-CIV-SDK.zip /tmp/ATAK-CIV*-SDK

mkdir -p /workspaces/plugins
ln -s "/workspaces/${BASENAME}" "/workspaces/plugins/${BASENAME}"

# for w in debug release
# do
#   if [ -f "/workspaces/${w}.keystore" ]; then
#     echo "${w}.keystore already exists in /workspaces, skipping generation."
#   else
#     echo "Generating ${w}.keystore..."
#     keytool -genkey -v -keystore ${w}.keystore -alias android${w}key \
#       -storepass android  -keypass android -keyalg RSA -keysize 2048 -validity 10000 \
#       -dname "CN=TAK, OU=TAK, O=TAK, L=TAK, S=TAK, C=SE"
#     sudo cp ${w}.keystore /workspaces
#   fi
# done

# Configure Android Studio application
ANDROID_STUDIO_FOLDER="/home/vscode/.config/Google/AndroidStudio${ANDROID_STUDIO_VERSION}"
mkdir -p "${ANDROID_STUDIO_FOLDER}"
echo "ide.no.survey=true" >> "${ANDROID_STUDIO_FOLDER}/idea.properties"

cat > "${ANDROID_STUDIO_FOLDER}/trusted-paths.json" <<EOF
{
  "trusted-paths": [
    "/workspaces"
  ]
}
EOF

sudo chown -R vscode /workspaces
