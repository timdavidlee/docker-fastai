# will be the most current version of the fastai library
FROM nvidia/cuda:10.0-cudnn7-runtime-ubuntu18.04 as base

LABEL maintainer="chaffixdev@gmail.com"

# Needed for string substitution 
SHELL ["/bin/bash", "-c"]
# Pick up some TF dependencies
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
        && rm -rf /var/lib/apt/lists/*


# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

# install python 3.6
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.6 \
    python3.6-distutils \
    python3.6-dev

RUN apt-get install wget
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3.6 get-pip.py

RUN pip3.6 install -U pip
RUN pip3.6 install -U setuptools

# Some TF tools expect a "python" binary
RUN ln -s /usr/bin/python3.6 /usr/bin/python 
RUN ln -s /usr/bin/pip3.6 /usr/bin/pip 

RUN pip install -U \
    pyyaml \
    scipy \
    ipython \
    mkl \
    mkl-include \
    cython \
    typing

# RUN pip install pandas \
#         numpy \
#         keras \
#         sklearn \
#         torchvision

# # fastai

# RUN pip install -U \
#     bs4 \
#     fastprogress \
#     matplotlib \
#     bottleneck \
#     numexpr \
#     nvidia-ml-py3 \
#     packaging \
#     pillow \
#     requests \
#     scipy \
#     spacy \
#     typing \
#     dataclasses \
#     jupyter \
#     jupyterlab \
#     nbconvert \
#     nbformat \
#     traitlets

# RUN pip install git+https://github.com/fastai/fastai.git

# install jupyter notebook

# Set up our notebook config.
RUN pip install \
    jupyterlab \
    jupyter \
    notebook \
    ipywidgets \
    nbextensions \
    jupyter_http_over_ws \
    jupyter_contrib_nbextensions

COPY jupyter_notebook_config.py /root/.jupyter/
COPY run_jupyter.sh /

EXPOSE 8888
EXPOSE 6006

CMD ["/run_jupyter.sh", "--allow-root"]
