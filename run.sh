docker run -it -d \
           --runtime=nvidia \
           --shm-size=1g \
           -p 8888:8888 \
           --name fastai_gpu_jup_container \
           -e PASSWORD="notebook" \
           chaffix/fastai:stable

docker ps | grep fastai
echo "this is running locally at 8888, ensure that this port is opened in your AWS / GCP settings"
docker logs fastai_gpu_jup_container