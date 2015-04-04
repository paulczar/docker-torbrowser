#FROM debian:latest
FROM debian:jessie

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

# to change user name: here, at USER instruction at the end of this file and in the "starttb" file (home dir)
ENV USER shannon

# from jess/iceweasel MAINTAINER Jessica Frazelle <jess@docker.com>
RUN sed -i.bak 's/jessie main/jessie main contrib/g' /etc/apt/sources.list && \
    apt-get update && apt-get install -y \
    flashplugin-nonfree \
    iceweasel \
    --no-install-recommends

RUN apt-get -y upgrade
RUN apt-get -y dist-upgrade

#RUN echo "deb http://mozilla.debian.net/ wheezy-backports iceweasel-release" >> /etc/apt/sources.list
#RUN apt-get update --fix-missing
#RUN apt-get install -y --force-yes -t wheezy-backports iceweasel

# Set locale (fix the locale warnings)
#RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || :

RUN useradd -m -d /home/$USER $USER

# Bug in docker messes up permissions of directories unless you do this first
#ADD . /home/$USER

# Add TOR browser
#ADD https://www.torproject.org/dist/torbrowser/4.5a4/tor-browser-linux64-4.5a4_en-US.tar.xz /home/$USER/tor.tar.xz
ADD https://www.torproject.org/dist/torbrowser/4.0.6/tor-browser-linux64-4.0.6_en-US.tar.xz /home/$USER/tor.tar.xz
RUN apt-get install -y xz-utils
RUN cd /home/$USER && tar xvf /home/$USER/tor.tar.xz && rm /home/$USER/tor.tar.xz
#ADD tor.tar.xz /home/$USER/

RUN mkdir /home/$USER/Downloads
RUN chown $USER:$USER /home/$USER
RUN chown $USER:$USER /home/$USER/*

RUN apt-get autoremove

USER shannon

ENV HOME /home/$USER

#CMD [/home/$USER/tor-browser_en-US/start-tor-browser]

