#!/bin/bash

set -euo pipefail

# Note: the "${BASH_REMATCH[2]}" here is REPO_NAME
# from [https://example.com/somebody/REPO_NAME.git] or [git@example.com:somebody/REPO_NAME.git]
function clone_or_pull () {
    if [[ $1 =~ ^(.*[/:])(.*)(\.git)$ ]] || [[ $1 =~ ^(http.*\/)(.*)$ ]]; then
        echo "${BASH_REMATCH[2]}" ;
        set +e ;
            git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules "$1" \
                || git -C "${BASH_REMATCH[2]}" pull --ff-only ;
        set -e ;
    else
        echo "[ERROR] Invalid URL: $1" ;
        return 1 ;
    fi ;
}


echo "########################################"
echo "[INFO] Downloading ComfyUI & Manager..."
echo "########################################"

set +e
cd /root
git clone https://github.com/comfyanonymous/ComfyUI.git || git -C "ComfyUI" pull --ff-only
cd /root/ComfyUI
# Using stable version (has a release tag)
git reset --hard "$(git tag | grep -e '^v' | sort -V | tail -1)"
set -e

cd /root/ComfyUI/custom_nodes
clone_or_pull https://github.com/ltdrdata/ComfyUI-Manager.git
clone_or_pull https://github.com/kijai/ComfyUI-WanVideoWrapper.git
clone_or_pull https://github.com/chflame163/ComfyUI_LayerStyle.git
clone_or_pull https://github.com/city96/ComfyUI-GGUF.git
clone_or_pull https://github.com/rgthree/rgthree-comfy.git
clone_or_pull https://github.com/yolain/ComfyUI-Easy-Use.git
clone_or_pull https://github.com/kijai/ComfyUI-KJNodes.git
clone_or_pull https://github.com/crystian/ComfyUI-Crystools.git
clone_or_pull https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
clone_or_pull https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git
clone_or_pull https://github.com/melMass/comfy_mtb.git
clone_or_pull https://github.com/christian-byrne/audio-separation-nodes-comfyui.git
clone_or_pull https://github.com/sipherxyz/comfyui-art-venture.git
clone_or_pull https://github.com/billwuhao/ComfyUI_IndexTTS.git
clone_or_pull https://github.com/Flow-two/ComfyUI-WanStartEndFramesNative.git
clone_or_pull https://github.com/fearnworks/ComfyUI_FearnworksNodes.git
clone_or_pull https://github.com/kijai/ComfyUI-MMAudio.git
clone_or_pull https://github.com/kael558/ComfyUI-GGUF-FantasyTalking.git


echo "########################################"
echo "[INFO] Downloading Custom Nodes..."
echo "########################################"

cd /root/ComfyUI/custom_nodes

# Workspace
clone_or_pull https://github.com/crystian/ComfyUI-Crystools.git


echo "########################################"
echo "[INFO] Downloading Models..."
echo "########################################"

# Models
cd /root/ComfyUI/models
aria2c \
  --input-file=/runner-scripts/download-models.txt \
  --allow-overwrite=false \
  --auto-file-renaming=false \
  --continue=true \
  --max-connection-per-server=5

# Finish
touch /root/.download-complete
