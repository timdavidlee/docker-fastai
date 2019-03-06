SAVE_DIR=$1

if [[ "$SAVEDIR" == "" ]]; then
  SAVE_DIR="$PWD/container_save/"
fi

echo "save directory: $SAVE_DIR"

docker run -it -d -rm \
           --runtime=nvidia \
           --shm-size=1g \
           -p 8888:8888 \
           -v $SAVE_DIR:/save_dir/ \
           --name fastai_gpu_jup_container \
           -e PASSWORD="notebook" \
           chaffix/fastai:stable

docker ps | grep fastai
echo "this is running locally at 8888, ensure that this port is opened in your AWS / GCP settings"
docker logs fastai_gpu_jup_container