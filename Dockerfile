FROM ubuntu:latest

RUN sed -i.bak -r 's@http://(jp\.)?archive\.ubuntu\.com/ubuntu/?@https://ftp.udx.icscoe.jp/Linux/ubuntu/@g' /etc/apt/sources.list

RUN apt update &&\
    apt install -y --no-install-recommends software-properties-common &&\
    add-apt-repository ppa:apt-fast/stable &&\
    apt update &&\
    apt install -y --no-install-recommends apt-fast &&\
    apt-fast update

RUN apt-fast install -y --no-install-recommends build-essential curl git locales tar tzdata wget zsh &&\
    locale-gen ja_JP.UTF-8 &&\
    locale-gen en_US.UTF-8 &&\
    apt-fast clean &&\
    rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Tokyo
ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=ja_JP:ja
ENV LC_ALL=ja_JP.UTF-8
ENV SHELL=/usr/bin/zsh

ARG CONTAINER_USER=user
RUN useradd -ms /bin/zsh $CONTAINER_USER &&\
    rm /home/$CONTAINER_USER/.bash_logout \
    /home/$CONTAINER_USER/.bashrc \
    /home/$CONTAINER_USER/.profile

# nvim
RUN wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz &&\
    tar -zxvf nvim-linux64.tar.gz &&\
    mv nvim-linux64/bin/nvim usr/bin/nvim &&\
    mv nvim-linux64/lib/nvim usr/lib/nvim &&\
    mv nvim-linux64/share/nvim/ usr/share/nvim &&\
    rm -rf nvim-linux64 &&\
    rm nvim-linux64.tar.gz

# Homebrew
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &&\
    mkdir -p /home/linuxbrew/.linuxbrew/var/run &&\
    chown -R $CONTAINER_USER /home/linuxbrew/.linuxbrew

USER $CONTAINER_USER
WORKDIR /home/$CONTAINER_USER/

RUN git clone https://github.com/npakk/dotfiles_for_docker.git dotfiles &&\
    mkdir -p ~/.cache/zsh \
    ~/.config/zsh \
    ~/.config/git \
    ~/.config/gh \
    ~/.config/lazygit \
    ~/.config/nvim &&\
    ln -s ~/dotfiles/.zshenv ~/.zshenv &&\
    ln -s ~/dotfiles/.gitconfig ~/.gitconfig &&\
    ln -s ~/dotfiles/.config/zsh/.zshrc ~/.config/zsh/.zshrc &&\
    ln -s ~/dotfiles/.config/zsh/autoload ~/.config/zsh/autoload &&\
    ln -s ~/dotfiles/.config/git/ignore ~/.config/git/ignore &&\
    ln -s ~/dotfiles/.config/gh/config.yml ~/.config/gh/config.ym &&\
    ln -s ~/dotfiles/.config/lazygit/config.yml ~/.config/lazygit/config.yml &&\
    ln -s ~/dotfiles/.config/nvim/init.lua ~/.config/nvim/init.lua &&\
    ln -s ~/dotfiles/.config/nvim/after ~/.config/nvim/after &&\
    ln -s ~/dotfiles/.config/nvim/spell ~/.config/nvim/spell &&\
    ln -s ~/dotfiles/.config/nvim/lua ~/.config/nvim/lua &&\
    ln -s ~/dotfiles/.config/nvim/snippets ~/.config/nvim/snippet &&\
    ln -s ~/dotfiles/.config/nvim/stylua.toml ~/.config/nvim/stylua.toml &&\
    ln -s ~/dotfiles/.config/nvim/selene.toml ~/.config/nvim/selene.toml &&\
    ln -s ~/dotfiles/.config/nvim/vim.toml ~/.config/nvim/vim.toml

RUN nvim +:q
CMD ["/bin/zsh"]
