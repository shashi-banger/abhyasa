
TAG=${1}
# standard paths
declare -r SCRIPT_DIR=$(dirname ${BASH_SOURCE[0]})
declare -r PROJROOT=$(realpath $SCRIPT_DIR/../)
declare -r DOCKER_BUILD_DIR="${PROJROOT}/docker/"

pushd $PROJROOT
tar -cvzf ${DOCKER_BUILD_DIR}/greeter.tgz $(git ls-files) 
pushd ${DOCKER_BUILD_DIR}

docker build -t ${TAG} .

