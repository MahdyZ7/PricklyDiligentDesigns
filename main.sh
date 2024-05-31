#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
GRAY='\033[0;37m'
NC='\033[0m'

## option 1
# alias valgrind='docker run -it --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --security-opt apparmor=unconfined --rm -v "$PWD:[<WRKDIR>]" <docker_hub_username>/<image_name> "/bin/zsh"
## option2
# alias valgrind='bash -c "$(curl backed)"'
cmd='bash -c "$(curl backed)"'

# the second option allows updates to go live faster

# check if goinfree is there (proxy for are you in 42)
if [ ! -d "$HOME/goinfre" ]; then
	echo -e "${RED} You must be using a terminal inside 42 lab ${NC}"
	exit 1
fi

# how to check before set up of docker ??
# set up goinfree
docker ps > /dev/null 2>&1
if [ ! $? -eq 0 ] || [ ! -f "$HOME/goinfre/com.docker.docker" ]; then
	osascript -e 'quit app "Docker"'
	rm -rf ~/.docker
	rm -rf ~/goinfre/docker
	mkdir -p ~/goinfre/com.docker.docker
	rm -rf ~/Library/Containers/com.docker.docker
	ln -s ~/goinfre/com.docker.docker ~/Library/Containers/com.docker.docker
fi


# open docker
docker ps > /dev/null 2>&1
if [ ! $? -eq 0 ]; then
	open -a docker                #what if docker does not open??
	echo -n "waiting for docker to start "
	timeout=120
	while [ $timeout -gt 0 ]; do
		docker ps > /dev/null 2>&1
		if [ $? -eq 0 ]; then
			echo
			break
		else
			echo -n "."
			sleep 1
			timeout=$((timeout - 1))
		fi
	done
	if [ $timeout -eq 0 ]; then
		echo -e "${RED}Docker failed to start.${NC}"
		echo -e "${RED}Please check docker is installed and try again.${NC}"
		exit 1
	fi
fi

# add alias
# if [ -f "$HOME/.bashrc" ]; then
#     echo "alias valgrind=$cmd" | tee -a "$HOME/.bashrc"
#     if [[ "$SHELL" == *bash* ]]; then
#         source "$HOME/.bashrc"
#     fi
# fi

if [ -f "$HOME/.zshrc" ]; then
	sed -i '' '/^alias valgrind=/d' ~/.zshrc
	echo "alias valgrind=$cmd" | tee -a "$HOME/.zshrc"
	# if [[ "$SHELL" == *zsh* ]]; then
	#     source "$HOME/.zshrc"
	# fi
fi