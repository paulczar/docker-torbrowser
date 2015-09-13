FROM debian:jessie
# MAINTAINER Jessica Frazelle <jess@docker.com>

COPY pin_torbrowser-launcher.pref /etc/apt/preferences.d/pin_torbrowser-launcher.pref
RUN DEBIAN_FRONTEND=noninteractive ;\
    sed --in-place 's/jessie main/jessie main contrib/g' /etc/apt/sources.list && \
    echo 'deb http://httpredir.debian.org/debian jessie-backports main contrib' >> /etc/apt/sources.list.d/backports.list && \
    apt-get update && \
    apt-get install --assume-yes --no-install-recommends \
        flashplugin-nonfree \
        iceweasel \
        torbrowser-launcher \
        xz-utils

# to change user name: here, at USER instruction at the end of this file and in the "starttb" file (home dir)
ENV USER shannon
ENV TOR_BROWSER_VERSION 5.0.2

RUN useradd --create-home --skel /bin/bash $USER

ADD https://www.torproject.org/dist/torbrowser/${TOR_BROWSER_VERSION}/tor-browser-linux64-${TOR_BROWSER_VERSION}_en-US.tar.xz /tmp/tor-browser.tar.xz
ADD https://www.torproject.org/dist/torbrowser/${TOR_BROWSER_VERSION}/tor-browser-linux64-${TOR_BROWSER_VERSION}_en-US.tar.xz.asc /tmp/tor-browser.tar.xz.asc
RUN cd /home/$USER && \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "EF6E 286D DA85 EA2A 4BA7  DE68 4E2C 6E87 9329 8290" && \
    gpg --verify /tmp/tor-browser.tar.xz.asc && \
    tar xvf /tmp/tor-browser.tar.xz && \
    rm /tmp/tor-browser.tar.xz

RUN chown --recursive $USER:$USER /home/$USER

USER $USER
ENV HOME /home/$USER
RUN mkdir /home/$USER/Downloads
