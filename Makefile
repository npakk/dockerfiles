.PHONY: all
all: build run

build:
	@read -p "WHICH DO YOU WANT TO BUILD: " BUILD; \
	read -sp "ENTER DOCKER USER PASSWORD: " PW; \
	read -p "ENTER GIT AUTHOR NAME: " GIT_NAME; \
	read -p "ENTER GIT AUTHOR EMAIL: " GIT_EMAIL; \
	(docker buildx build --no-cache --platform linux/amd64 --build-arg PW="$$PW" GIT_AUTHOR_NAME="$$GIT_NAME" GIT_AUTHOR_EMAIL="$$GIT_EMAIL" -t dotfiles "$$BUILD"/)

run:
	@docker run --platform linux/amd64 -it dotfiles:latest

.PHONY: clean
clean:
	@docker rm -f `docker ps -aq`
	@docker image prune -af
