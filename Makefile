.PHONY: all
all: build run

build:
	@read -p "WHICH DO YOU WANT TO BUILD: " BUILD; \
	read -p "ENTER GIT AUTHOR NAME: " GIT_NAME; \
	read -p "ENTER GIT AUTHOR EMAIL: " GIT_EMAIL; \
	(docker buildx build --no-cache --build-arg GIT_NAME="$$GIT_NAME" --build-arg GIT_EMAIL="$$GIT_EMAIL" -t dotfiles "$$BUILD"/)

run:
	@docker run -it dotfiles:latest tmux

.PHONY: clean
clean:
	@docker rm -f `docker ps -aq`
	@docker image prune -af
