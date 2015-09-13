#FROM debian:latest
FROM debian:jessie

# Set the env variable DEBIAN_FRONTEND to noninteractive
# to change user name: here, at USER instruction at the end of this file and in the "starttb" file (home dir)

ENV DEBIAN_FRONTEND=noninteractive VERSION=5.0.2 HOME=/home/anon


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

RUN useradd -m -d /home/anon anon

# Bug in docker messes up permissions of directories unless you do this first
#ADD . /home/anon

# Add TOR browser
ADD https://www.torproject.org/dist/torbrowser/${VERSION}/tor-browser-linux64-${VERSION}_en-US.tar.xz /home/anon/tor.tar.xz
RUN apt-get install -y xz-utils
RUN cd /home/anon && tar xvf /home/anon/tor.tar.xz && rm /home/anon/tor.tar.xz
#ADD tor.tar.xz /home/anon/

RUN mkdir /home/anon/Downloads && \
    chown anon:anon /home/$USER && \
    chown anon:anon /home/$USER/* && \
    apt-get autoremove

USER anon

CMD /home/anon/tor-browser_en-US/Browser/start-tor-browser

