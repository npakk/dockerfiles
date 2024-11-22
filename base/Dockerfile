FROM ubuntu:24.10

RUN sed -i.bak -r 's@http://(jp\.)?archive\.ubuntu\.com/ubuntu/?@https://ftp.udx.icscoe.jp/Linux/ubuntu/@g' /etc/apt/sources.list &&\
    apt-get update &&\
    apt-get install -y --no-install-recommends \
    build-essential ca-certificates curl git locales lua5.1 luarocks sudo tzdata zsh &&\
    locale-gen ja_JP.UTF-8 en_US.UTF-8 &&\
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - &&\
    apt-get install -y --no-install-recommends nodejs &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Tokyo
ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=ja_JP:ja
ENV LC_ALL=ja_JP.UTF-8
ENV SHELL=/usr/bin/zsh

ARG USR=user
ARG PW
RUN useradd -ms /usr/bin/zsh -G sudo $USR &&\
    echo $USR:$PW | chpasswd &&\
    echo "$USR ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# nvim
RUN curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz &&\
    tar -zxf nvim-linux64.tar.gz &&\
    mv nvim-linux64/bin/nvim usr/bin/nvim &&\
    mv nvim-linux64/lib/nvim usr/lib/nvim &&\
    mv nvim-linux64/share/nvim/ usr/share/nvim &&\
    rm -rf nvim-linux64 &&\
    rm nvim-linux64.tar.gz

# Homebrew
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
USER $USR
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

WORKDIR /home/$USR/
RUN git clone https://github.com/npakk/dotfiles_for_docker.git dotfiles &&\
    mkdir -p ~/.cache/zsh &&\
    ln -s ~/dotfiles/.zshenv ~/.zshenv &&\
    ln -s ~/dotfiles/.gitconfig ~/.gitconfig &&\
    ln -s ~/dotfiles/.config ~/.config &&\
    rm /home/$USR/.bash_logout \
    /home/$USR/.bashrc \
    /home/$USR/.profile \
    /home/$USR/.sudo_as_admin_successful

ENTRYPOINT ["/usr/bin/zsh"]
