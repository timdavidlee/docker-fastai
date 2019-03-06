PASSWORD=$1

if [[ "$PASSWORD" == "" ]]; then
  echo "please provide a notebook password after the run command"
  echo "./run.sh <MYPASSWORD>"
  exit 1
fi

docker run --rm -it -d \
           --runtime=nvidia \
           --shm-size=1g \
           -p 8888 \
           -v "persistdata/:/persistdata/" \
           --name fastai_gpu_jup_container \
           -e PASSWORD=$PASSWORD \
           chaffix/fastai:stable