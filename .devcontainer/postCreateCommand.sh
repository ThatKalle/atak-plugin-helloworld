#!/bin/bash
set -e

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --atak-sdk) 
            ATAK_SDK="$2"
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

# Create default keystores
for w in debug release
do
  if [ -f "/workspaces/${w}.keystore" ]; then
    echo "${w}.keystore already exists in /workspaces, skipping generation."
  else
    echo "Generating ${w}.keystore..."
    keytool -genkey -v -keystore ${w}.keystore -alias android${w}key \
      -storepass android -keypass android -keyalg RSA -keysize 2048 -validity 10000 \
      -dname "CN=TAK, OU=TAK, O=TAK, L=TAK, S=TAK, C=SE"
    sudo cp ${w}.keystore /workspaces
  fi
done

# Apply SDK
SDK_ZIP="/workspaces/${BASENAME}/.devcontainer/files/${ATAK_SDK}"
SDK_PATH="/workspaces/${BASENAME}/.sdk"

if [ ! -f "$SDK_ZIP" ]; then
  echo "SDK zip not found at $SDK_ZIP."
  echo "Rebuild the container."
  exit 1
fi

if [ ! -f "$SDK_PATH/atak-gradle-takdev.jar" ]; then
  echo "Extracting SDK..."
  unzip -q $SDK_ZIP -d /tmp
  mkdir -p $SDK_PATH
  sudo cp -r /tmp/ATAK-CIV*-SDK/* $SDK_PATH
  sudo rm -rf /tmp/ATAK-CIV-SDK.zip /tmp/ATAK-CIV*-SDK
fi

# Configure Android Studio application
DATADIRECTORYNAME=$(jq -r '.dataDirectoryName' /opt/android-studio/product-info.json)
ANDROID_STUDIO_FOLDER="/home/vscode/.config/Google/${DATADIRECTORYNAME}"
mkdir -p "${ANDROID_STUDIO_FOLDER}/options"

cat > "${ANDROID_STUDIO_FOLDER}/options/trusted-paths.xml" <<EOF
<application>
  <component name="Trusted.Paths">
    <option name="TRUSTED_PROJECT_PATHS">
      <map>
        <entry key="/workspaces/../${BASENAME}" value="true" />
        <entry key="/workspaces/${BASENAME}" value="true" />
      </map>
    </option>
  </component>
  <component name="Trusted.Paths.Settings">
    <option name="TRUSTED_PATHS">
      <list>
        <option value="/workspaces" />
      </list>
    </option>
  </component>
</application>
EOF

sudo chown -R vscode /workspaces
