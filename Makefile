build:
	@docker build --no-cache -t dotfiles .

run:
	@docker run -it dotfiles:latest
