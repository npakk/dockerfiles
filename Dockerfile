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
    # mkdir -p /home/linuxbrew/.linuxbrew/var/run &&\
    # chown -R $CONTAINER_USER /home/linuxbrew/.linuxbrew
    chown -R $CONTAINER_USER /home/linuxbrew/.linuxbrew/Cellar \
    /home/linuxbrew/.linuxbrew/Homebrew \
    /home/linuxbrew/.linuxbrew/bin \
    /home/linuxbrew/.linuxbrew/sbin \
    /home/linuxbrew/.linuxbrew/etc \
    /home/linuxbrew/.linuxbrew/etc/bash_completion.d \
    /home/linuxbrew/.linuxbrew/include \
    /home/linuxbrew/.linuxbrew/lib \
    /home/linuxbrew/.linuxbrew/opt \
    /home/linuxbrew/.linuxbrew/share \
    /home/linuxbrew/.linuxbrew/share/doc \
    /home/linuxbrew/.linuxbrew/share/man \
    /home/linuxbrew/.linuxbrew/share/man/man1 \
    /home/linuxbrew/.linuxbrew/share/zsh \
    /home/linuxbrew/.linuxbrew/share/zsh/site-functions \
    /home/linuxbrew/.linuxbrew/var/homebrew/linked \
    /home/linuxbrew/.linuxbrew/var/homebrew/locks &&\
    chmod -R go-w /home/linuxbrew/.linuxbrew/share

USER $CONTAINER_USER
WORKDIR /home/$CONTAINER_USER/

RUN git clone https://github.com/npakk/dotfiles_for_docker.git dotfiles &&\
    mkdir -p ~/.cache/zsh &&\
    ln -s ~/dotfiles/.zshenv ~/.zshenv &&\
    ln -s ~/dotfiles/.gitconfig ~/.gitconfig &&\
    ln -s ~/dotfiles/.config ~/.config

ENTRYPOINT ["/usr/bin/zsh"]
