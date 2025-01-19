FROM ubuntu:24.10 AS base
ARG TARGETARCH
ARG BAT=0.25.0 DELTA=0.18.2 EZA=0.20.17 FD=10.2.0 FZF=0.57.0 GH=2.65.0 GHQ=1.7.1 LAZYGIT=0.45.2 RG=14.1.1 STARSHIP=1.22.1

RUN sed -i.bak -r 's@http://(jp\.)?archive\.ubuntu\.com/ubuntu/?@https://ftp.udx.icscoe.jp/Linux/ubuntu/@g' /etc/apt/sources.list &&\
    apt-get update && apt-get install -y --no-install-recommends \
    build-essential ca-certificates curl git libevent-dev unzip

FROM base AS builder-tmux

RUN apt-get update && apt-get install -y --no-install-recommends \
    automake bison libncurses5-dev pkg-config

RUN git clone https://github.com/tmux/tmux.git -b 3.5a --depth 1 &&\
    cd tmux &&\
    sh autogen.sh &&\
    ./configure &&\
    make && make install

FROM base AS builder-neovim

RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake gettext

RUN git clone https://github.com/neovim/neovim.git -b nightly --depth 1 &&\
    cd neovim &&\
    make CMAKE_BUILD_TYPE=RelWithDebInfo &&\
    make install

FROM node:23-slim AS builder-node

RUN npm install -g git-cz neovim

FROM base AS builder-rust

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable &&\
    /root/.cargo/bin/cargo install selene stylua

FROM base AS my-amd64
RUN mkdir /tmp/packages && cd /tmp/packages &&\
    curl -LO https://github.com/sharkdp/bat/releases/download/v${BAT}/bat-v${BAT}-x86_64-unknown-linux-gnu.tar.gz &&\
    tar -zxf bat-v${BAT}-x86_64-unknown-linux-gnu.tar.gz &&\
    mv bat-v${BAT}-x86_64-unknown-linux-gnu/bat /usr/local/bin &&\
    curl -LO https://github.com/dandavison/delta/releases/download/${DELTA}/delta-${DELTA}-x86_64-unknown-linux-gnu.tar.gz &&\
    tar -zxf delta-${DELTA}-x86_64-unknown-linux-gnu.tar.gz &&\
    mv delta-${DELTA}-x86_64-unknown-linux-gnu/delta /usr/local/bin &&\
    curl -LO https://github.com/eza-community/eza/releases/download/v${EZA}/eza_x86_64-unknown-linux-gnu.tar.gz &&\
    tar -zxf eza_x86_64-unknown-linux-gnu.tar.gz &&\
    mv eza /usr/local/bin &&\
    curl -LO https://github.com/sharkdp/fd/releases/download/v${FD}/fd-v${FD}-x86_64-unknown-linux-gnu.tar.gz &&\
    tar -zxf fd-v${FD}-x86_64-unknown-linux-gnu.tar.gz &&\
    mv fd-v${FD}-x86_64-unknown-linux-gnu/fd /usr/local/bin &&\
    curl -LO https://github.com/junegunn/fzf/releases/download/v${FZF}/fzf-${FZF}-linux_amd64.tar.gz &&\
    tar -zxf fzf-${FZF}-linux_amd64.tar.gz &&\
    mv fzf /usr/local/bin &&\
    curl -LO https://github.com/cli/cli/releases/download/v${GH}/gh_${GH}_linux_amd64.tar.gz &&\
    tar -zxf gh_${GH}_linux_amd64.tar.gz &&\
    mv gh_${GH}_linux_amd64/bin/gh /usr/local/bin &&\
    curl -LO https://github.com/x-motemen/ghq/releases/download/v${GHQ}/ghq_linux_amd64.zip &&\
    unzip ghq_linux_amd64.zip &&\
    mv ghq_linux_amd64/ghq /usr/local/bin &&\
    curl -LO https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT}/lazygit_${LAZYGIT}_Linux_x86_64.tar.gz &&\
    tar -zxf lazygit_${LAZYGIT}_Linux_x86_64.tar.gz &&\
    mv lazygit /usr/local/bin &&\
    curl -LO https://github.com/BurntSushi/ripgrep/releases/download/${RG}/ripgrep-${RG}-x86_64-unknown-linux-musl.tar.gz &&\
    tar -zxf ripgrep-${RG}-x86_64-unknown-linux-musl.tar.gz &&\
    mv ripgrep-${RG}-x86_64-unknown-linux-musl/rg /usr/local/bin &&\
    curl -LO https://github.com/starship/starship/releases/download/v${STARSHIP}/starship-x86_64-unknown-linux-gnu.tar.gz &&\
    tar -zxf starship-x86_64-unknown-linux-gnu.tar.gz &&\
    mv starship /usr/local/bin &&\
    rm -rf /tmp/packages

FROM base AS my-arm64
RUN mkdir /tmp/packages && cd /tmp/packages &&\
    curl -LO https://github.com/sharkdp/bat/releases/download/v${BAT}/bat-v${BAT}-aarch64-unknown-linux-gnu.tar.gz &&\
    tar -zxf bat-v${BAT}-aarch64-unknown-linux-gnu.tar.gz &&\
    mv bat-v${BAT}-aarch64-unknown-linux-gnu/bat /usr/local/bin &&\
    curl -LO https://github.com/dandavison/delta/releases/download/${DELTA}/delta-${DELTA}-aarch64-unknown-linux-gnu.tar.gz &&\
    tar -zxf delta-${DELTA}-aarch64-unknown-linux-gnu.tar.gz &&\
    mv delta-${DELTA}-aarch64-unknown-linux-gnu/delta /usr/local/bin &&\
    curl -LO https://github.com/eza-community/eza/releases/download/v${EZA}/eza_aarch64-unknown-linux-gnu.tar.gz &&\
    tar -zxf eza_aarch64-unknown-linux-gnu.tar.gz &&\
    mv eza /usr/local/bin &&\
    curl -LO https://github.com/sharkdp/fd/releases/download/v${FD}/fd-v${FD}-aarch64-unknown-linux-gnu.tar.gz &&\
    tar -zxf fd-v${FD}-aarch64-unknown-linux-gnu.tar.gz &&\
    mv fd-v${FD}-aarch64-unknown-linux-gnu/fd /usr/local/bin &&\
    curl -LO https://github.com/junegunn/fzf/releases/download/v${FZF}/fzf-${FZF}-linux_arm64.tar.gz &&\
    tar -zxf fzf-${FZF}-linux_arm64.tar.gz &&\
    mv fzf /usr/local/bin &&\
    curl -LO https://github.com/cli/cli/releases/download/v${GH}/gh_${GH}_linux_arm64.tar.gz &&\
    tar -zxf gh_${GH}_linux_arm64.tar.gz &&\
    mv gh_${GH}_linux_arm64/bin/gh /usr/local/bin &&\
    curl -LO https://github.com/x-motemen/ghq/releases/download/v${GHQ}/ghq_linux_arm64.zip &&\
    unzip ghq_linux_arm64.zip &&\
    mv ghq_linux_arm64/ghq /usr/local/bin &&\
    curl -LO https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT}/lazygit_${LAZYGIT}_Linux_arm64.tar.gz &&\
    tar -zxf lazygit_${LAZYGIT}_Linux_arm64.tar.gz &&\
    mv lazygit /usr/local/bin &&\
    curl -LO https://github.com/BurntSushi/ripgrep/releases/download/${RG}/ripgrep-${RG}-aarch64-unknown-linux-gnu.tar.gz &&\
    tar -zxf ripgrep-${RG}-aarch64-unknown-linux-gnu.tar.gz &&\
    mv ripgrep-${RG}-aarch64-unknown-linux-gnu/rg /usr/local/bin &&\
    curl -LO https://github.com/starship/starship/releases/download/v${STARSHIP}/starship-aarch64-unknown-linux-musl.tar.gz &&\
    tar -zxf starship-aarch64-unknown-linux-musl.tar.gz &&\
    mv starship /usr/local/bin &&\
    rm -rf /tmp/packages

FROM my-${TARGETARCH}

ENV TZ=Asia/Tokyo LANG=ja_JP.UTF-8 LANGUAGE=ja_JP:ja LC_ALL=ja_JP.UTF-8 SHELL=/usr/bin/zsh

RUN apt-get update && apt-get install -y --no-install-recommends \
    jq locales lua5.1 luarocks tzdata zsh &&\
    locale-gen ja_JP.UTF-8 en_US.UTF-8 &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

ARG GITNAME=example GITEMAIL=example@example.com

COPY --from=builder-node /usr/local/bin /usr/local/bin
COPY --from=builder-node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=builder-tmux /usr/local/bin/tmux /usr/local/bin/tmux
COPY --from=builder-neovim /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=builder-neovim /usr/local/lib/nvim /usr/local/lib/nvim
COPY --from=builder-neovim /usr/local/share/nvim /usr/local/share/nvim
COPY --from=builder-rust ["/root/.cargo/bin/selene","/root/.cargo/bin/stylua","/usr/local/bin/"]

RUN git clone https://github.com/rupa/z.git /root/.local/share/z/path/to/ --depth 1 &&\
    git clone https://github.com/zsh-users/zsh-autosuggestions /root/.local/share/zsh/zsh-autosuggestions --depth 1 &&\
    git clone https://github.com/zsh-users/zsh-completions.git /root/.local/share/zsh/zsh-completions --depth 1 &&\
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.local/share/zsh/zsh-syntax-highlighting --depth 1 &&\
    git clone https://github.com/gkeep/iceberg-dark.git /root/.local/share/tmux/plugins/iceberg-dark --depth 1

RUN git clone https://github.com/npakk/dotfiles_for_docker.git /root/dotfiles &&\
    mkdir -p /root/.cache/zsh \
    /root/.local/state/zsh \
    /root/.local/share/zsh/completions &&\
    ln -s /root/dotfiles/.zshenv /root/.zshenv &&\
    ln -s /root/dotfiles/.gitconfig /root/.gitconfig &&\
    ln -s /root/dotfiles/.config /root/.config &&\
    chmod +x /root/dotfiles/scripts/gitconfig.local.sh &&\
    /root/dotfiles/scripts/gitconfig.local.sh ${GITNAME} ${GITEMAIL}

RUN nvim +:q
