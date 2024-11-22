.PHONY: all
all: build run

build: Dockerfile
	@read -p "ENTER DOCKER USER PASSWORD: " PW; \
	(docker buildx build --no-cache --build-arg PW="$$PW" -t dotfiles .)

run: 
	@docker run -it dotfiles:latest

.PHONY: clean
clean:
	@docker rm -f `docker ps -aq`
	@docker image prune -af
