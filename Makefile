.PHONY: all
all: Dockerfile build run

build: Dockerfile
	@docker build --no-cache -t dotfiles .

run: Dockerfile
	@docker run -it dotfiles:latest
