# CUDA-Based Fastai Docker Image

There's many great services out there for `fastai`. These are listed on the [fastai course page](https://course.fast.ai/), such as Crestle, Paperspace, Colab, SageMaker, and many more.

I made this docker to test some of the library out on company hardware, and had to make some adaptations. 

##  Why docker?

This is convenient if you switch workplaces a lot, and don't want to do the full installation of CUDA, python, fastai, and pytorch every single time.

###  Method 1: Pull the image from docker hub

```
docker pull chaffix/fastai:stable
```

#### Run the image once pulled

Need to supply a save directory location (otherwise all your data goes bye-bye once the container stops). Also set the password for the jupyter notebook

```
docker run -it -d --rm \
           --runtime=nvidia \
           --shm-size=1g \
           -p 8888:8888 \
           -v $SAVE_DIR:/fastai/save_dir/ \
           --name fastai_gpu_jup_container \
           -e PASSWORD=$PASSWORD \
           chaffix/fastai:stable
```

#### Stop container when done

```
# same name as when run is called
# will auto-dispose of itself (--rm) no need to run docker rm
docker stop fastai_gpu_jup_container
```

## Installed on this docker:

To be clear, this docker will run on any system that docker-ce is installed. [The official website](https://docs.docker.com/) has the installation options on the left.

- **CUDA**:10.0
- **CUDNN**:7
- **Python**:3.7
- **Ubuntu**:18.04


### Method 2: Build and run Docker from Github (this repo)

Pull the repo

```
git clone https://github.com/timdavidlee/docker-fastai.git
```

Build the image

```
./build.sh
```

Start a container

```
./run.sh <SAVE_DIR (defaults to {pwd}/save_dir/)> <PASSWORD (default is notebook)>
```



