sudo docker buildx create --use
sudo docker buildx build -f Dockerfile --platform linux/amd64 -t esmivn/comfyui-boot:cu124-slim-7 --push .