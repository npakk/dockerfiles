.PHONY: all
all: build run

build:
	@read -p "WHICH DO YOU WANT TO BUILD: " BUILD; \
	read -p "ENTER GIT AUTHOR NAME: " GITNAME; \
	read -p "ENTER GIT AUTHOR EMAIL: " GITEMAIL; \
	(docker buildx build --no-cache --build-arg UID="$$(id -u $$USER)" --build-arg GID="$$(id -g $$USER)" --build-arg USERNAME="$$(id -nu $$USER)" --build-arg GROUPNAME="$$(id -ng $$USER)" --build-arg GITNAME="$$GITNAME" --build-arg GITEMAIL="$$GITEMAIL" -t dotfiles "$$BUILD"/)

run:
	@docker run -it dotfiles:latest tmux

.PHONY: clean
clean:
	@docker rm -f `docker ps -aq`
	@docker image prune -af
	@docker volume prune -af
	@docker network prune -f
