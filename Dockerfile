FROM debian:jessie

# Set the env variable DEBIAN_FRONTEND to noninteractive
# to change user name: here, at USER instruction at the end of this file and in the "starttb" file (home dir)

ENV DEBIAN_FRONTEND=noninteractive VERSION=7.5.6 HOME=/home/anon


RUN apt-get update && \
    apt-get -y dist-upgrade && \
    sed -i.bak 's/jessie main/jessie main contrib/g' /etc/apt/sources.list && \
    apt-get update && apt-get install -y \
    flashplugin-nonfree \
    iceweasel \
    xz-utils \
    curl \
    --no-install-recommends && \
    localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || :

RUN useradd -m -d /home/anon anon

WORKDIR /home/anon

# Add TOR browser
RUN \
    curl -sSL -o /home/anon/tor.tar.xz \
      https://www.torproject.org/dist/torbrowser/${VERSION}/tor-browser-linux64-${VERSION}_en-US.tar.xz && \
    curl -sSL -o /home/anon/tor.tar.xz.asc \
      https://www.torproject.org/dist/torbrowser/${VERSION}/tor-browser-linux64-${VERSION}_en-US.tar.xz.asc && \
    gpg --keyserver ha.pool.sks-keyservers.net \
      --recv-keys "EF6E 286D DA85 EA2A 4BA7  DE68 4E2C 6E87 9329 8290" && \
    gpg --verify /home/anon/tor.tar.xz.asc && \
    tar xvf /home/anon/tor.tar.xz && \
    rm -f /home/anon/tor.tar.xz*

RUN mkdir /home/anon/Downloads && \
    chown -R anon:anon /home/anon && \
    apt-get autoremove

USER anon

CMD /home/anon/tor-browser_en-US/Browser/start-tor-browser

