.PHONY: all
all: build run

build: Dockerfile
	@docker build --no-cache -t dotfiles .

run: 
	@docker run -it dotfiles:latest

.PHONY: clean
clean:
	@docker rm -f `docker ps -aq`
	@docker image prune -af
