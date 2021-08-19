FROM ubuntu:18.04
RUN mkdir -p /home/appuser && addgroup appuser && useradd -d /home/appuser -g appuser appuser && chown appuser:appuser /home/appuser

RUN apt-get update && \
    apt-get install -y software-properties-common \ 
    git # git && \ before
#     add-apt-repository ppa:neovim-ppa/unstable && \
#     apt-get update && \
#     apt-get install -y neovim
# 
USER appuser
WORKDIR /home/appuser
COPY ./nvim/install.sh /home/appuser
RUN bash install.sh

# ENTRYPOINT ["nvim"]

