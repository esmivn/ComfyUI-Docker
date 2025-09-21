# allow script execution:
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# to run this script:
# powershell.exe -File .\dk_push_x86.ps1

# 1) create and switch to a new builder instance
docker buildx create --name winbuilder --use

# 2) build for linux/amd64, tag it and push
docker buildx build `
  -f .\Dockerfile `
  --platform linux/amd64 `
  -t esmivn/comfyui-boot:cu124-slim-8 `
  --push `
  .