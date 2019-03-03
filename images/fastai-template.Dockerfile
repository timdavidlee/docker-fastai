ARG CUDA
ARG CUDNN
ARG UBUNTU_VERSION
ARG PYTHON_VERSION

FROM nvidia/cuda:${CUDA}-cudnn${CUDNN}-devel-ubuntu${UBUNTU_VERSION} as base

RUN echo "cuda version: $CUDA"
RUN echo "cudnn version: $CUDNN"
RUN echo "ubuntu version: $UBUNTU_VERSION"
RUN echo "python version: $PYTHON_VERSION"

LABEL maintainer="chaffixdev@gmail.com"

# # Needed for string substitution 
# SHELL ["/bin/bash", "-c"]

# Pick up some basic dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        pkg-config \
        software-properties-common \
        unzip \
        vim \
        libjpeg-dev \
        libpng-dev \
        git \
        wget \
        && rm -rf /var/lib/apt/lists/*


# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8


# install python
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update && apt-get install -y --no-install-recommends \
    python${PYTHON_VERSION} \
    python${PYTHON_VERSION}-distutils \
    python${PYTHON_VERSION}-dev

RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python${PYTHON_VERSION} get-pip.py

RUN pip${PYTHON_VERSION} install -U pip
RUN pip${PYTHON_VERSION} install -U setuptools

# Some TF tools expect a "python" binary
RUN ln -s /usr/bin/python${PYTHON_VERSION} /usr/bin/python 
RUN ln -s /usr/bin/pip${PYTHON_VERSION} /usr/bin/pip 

RUN pip install -U \
    pyyaml \
    scipy \
    ipython \
    mkl \
    mkl-include \
    cython \
    typing

RUN pip install pandas \
        numpy \
        keras \
        sklearn

RUN pip install https://download.pytorch.org/whl/cu${CUDA/.}/torch-1.0.1.post2-cp${PYTHON_VERSION}-cp${PYTHON_VERSION}m-linux_x86_64.whl \
    pip install torchvision

# fastai

RUN pip install -U \
    bs4 \
    fastprogress \
    matplotlib \
    bottleneck \
    numexpr \
    nvidia-ml-py3 \
    packaging \
    pillow \
    requests \
    scipy \
    spacy \
    typing \
    dataclasses \
    jupyter \
    jupyterlab \
    nbconvert \
    nbformat \
    traitlets

RUN pip install git+https://github.com/fastai/fastai.git

# jupyter