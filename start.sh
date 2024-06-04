#!/bin/bash

#check and start docker if needed
curl -s -H 'Range: bytes' https://raw.githubusercontent.com/MahdyZ7/PricklyDiligentDesigns/main/start_docker.sh | bash

#run docker container
docker run -it --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --security-opt apparmor=unconfined --rm -v "$PWD:/home/Developer" mahdyz7/rust_container:latest