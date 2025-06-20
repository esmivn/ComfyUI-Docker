# allow script execution:
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# 1) create and switch to a new builder instance
docker buildx create --name winbuilder --use

# 2) build for linux/amd64, tag it and push
docker buildx build `
  -f .\Dockerfile `
  --platform linux/amd64 `
  -t esmivn/comfyui-boot:cu124-slim-2 `
  --push `
  .