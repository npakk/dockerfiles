FROM ubuntu:24.10

RUN sed -i.bak -r 's@http://(jp\.)?archive\.ubuntu\.com/ubuntu/?@https://ftp.udx.icscoe.jp/Linux/ubuntu/@g' /etc/apt/sources.list

RUN apt-get update &&\
    apt-get install -y --no-install-recommends build-essential ca-certificates curl git locales lua5.1 luarocks nodejs tar tzdata zsh &&\
    locale-gen ja_JP.UTF-8 en_US.UTF-8 &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Tokyo
ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=ja_JP:ja
ENV LC_ALL=ja_JP.UTF-8
ENV SHELL=/usr/bin/zsh

ARG CONTAINER_USER=user
RUN useradd -ms /usr/bin/zsh $CONTAINER_USER &&\
    rm /home/$CONTAINER_USER/.bash_logout \
    /home/$CONTAINER_USER/.bashrc \
    /home/$CONTAINER_USER/.profile

# nvim
RUN curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz &&\
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
    ln -s ~/dotfiles/.zshenv ~/.zshenv &&\
    ln -s ~/dotfiles/.gitconfig ~/.gitconfig &&\
    ln -s ~/dotfiles/.config ~/.config

ENTRYPOINT ["/usr/bin/zsh"]
