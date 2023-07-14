SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

cd $SCRIPT_DIR

IMAGE_NAME=$1
CONTAINER_NAME=$2

docker build -t $IMAGE_NAME .

docker run \
-it \
--privileged \
--shm-size=8gb \
--net=host \
--name=${CONTAINER_NAME} \
${IMAGE_NAME}