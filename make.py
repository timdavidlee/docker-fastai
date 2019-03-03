import json
from yaml import load, dump

def mk_image_compose_block(dict_args):
    docker_compose_build_image = {
        "build":{
            "context" : "./",
            "dockerfile": "images/fastai-template.Dockerfile",
            "args": dict_args
        }
    }
    return docker_compose_build_image

def mk_stable_compose_block():
    docker_compose_build_image = {
        "build":{
            "context" : "./",
            "dockerfile": "images/fastai-stable.Dockerfile"
        },
        "image":'chaffix/fastai:1.0-stable',
    }
    return docker_compose_build_image


def main():
    with open("combinations.json") as f:
        system_combinations = json.load(f)

    print(system_combinations)

    docker_compose_yml = {
        "version":"3.7",
        "services":{}
    }

    stable_compose_block = mk_stable_compose_block()

    docker_compose_yml['services']['stable'] = stable_compose_block


    SERVICE_NAME_TEMPLATE = "cuda{CUDA}_cudnn{CUDNN}_ub{UBUNTU_VERSION}_py{PYTHON_VERSION}"
    IMAGE_NAME_TEMPLATE = "1.0-cuda{CUDA}_cudnn{CUDNN}_ub{UBUNTU_VERSION}_py{PYTHON_VERSION}"

    for cuda_image in system_combinations['CUDA_IMAGES']:
        for py_version in system_combinations['PYTHON_VERSIONS']:
            service_name = SERVICE_NAME_TEMPLATE.format(CUDA=cuda_image['CUDA'],
                                                        CUDNN=cuda_image['CUDNN'],
                                                        UBUNTU_VERSION=cuda_image['UBUNTU_VERSION'],
                                                        PYTHON_VERSION=py_version,
                                                        )

            service_name = service_name.replace(".", "")

            image_name =  IMAGE_NAME_TEMPLATE.format(CUDA=cuda_image['CUDA'],
                                                     CUDNN=cuda_image['CUDNN'],
                                                     UBUNTU_VERSION=cuda_image['UBUNTU_VERSION'],
                                                     PYTHON_VERSION=py_version,
                                                     )     
            build_args = dict(cuda_image)
            build_args['PYTHON_VERSION'] = py_version
            # build_args = [{ky:vl} for ky, vl in build_args.items()]

            docker_compose_block = mk_image_compose_block(build_args)
            docker_compose_block['image'] = 'chaffix/fastai:{0}'.format(image_name) 
                          
            docker_compose_yml['services'][service_name] = docker_compose_block

    with open("docker-compose.yml", 'w') as f:
        dump(docker_compose_yml, f, default_flow_style=False)

if __name__ == "__main__":
    main()