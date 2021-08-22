FROM ubuntu:18.04
RUN mkdir -p /home/appuser && addgroup appuser && useradd -d /home/appuser -g appuser appuser && chown appuser:appuser /home/appuser && \
    echo "appuser:appuser" | chpasswd && adduser appuser sudo
RUN apt-get update && \
    apt-get install -y sudo apt-utils software-properties-common \ 
    git curl gcc g++ && \
    add-apt-repository ppa:neovim-ppa/unstable && \
    apt-get update && \
    apt-get install -y neovim && \
    curl -LO https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb && \
    dpkg -i ripgrep_12.1.1_amd64.deb

WORKDIR /home/appuser
USER appuser
COPY ./nvim/nvim-config.sh /home/appuser
RUN bash nvim-config.sh 
# ENTRYPOINT ["nvim"]


