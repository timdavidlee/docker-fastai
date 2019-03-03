docker build --rm \
             -f fastai-template.Dockerfile \
             --build-arg CUDA='10.0' \
             --build-arg UBUNTU_VERSION='18.04' \
             --build-arg PYTHON_VERSION='3.6' \
             --build-arg CUDNN='7'
             chaffix/fastai:test_build
