.PHONY: all
all: build run

build:
	@read -p "WHICH DO YOU WANT TO BUILD: " BUILD; \
	read -sp "ENTER DOCKER USER PASSWORD: " PW; \
	(docker buildx build --no-cache --platform linux/amd64 --build-arg PW="$$PW" -t dotfiles "$$BUILD"/)

run:
	@docker run --platform linux/amd64 -it dotfiles:latest

.PHONY: clean
clean:
	@docker rm -f `docker ps -aq`
	@docker image prune -af
