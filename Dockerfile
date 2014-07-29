# This file creates a container that runs X11 and SSH services
# The ssh is used to forward X11 and provide you encrypted data
# communication between the docker container and your local 
# machine.
#
# Xpra allows to display the programs running inside of the
# container such as Firefox, LibreOffice, xterm, etc. 
# with disconnection and reconnection capabilities
#
# The applications are rootless, therefore the client machine 
# manages the windows displayed.
# 
# ROX-Filer creates a very minimalist way to manage 
# files and icons on the desktop. 
#
# Author: Paul Czarkowski
# Date: 07/12/2013
# Based on :- https://github.com/rogaha/docker-desktop


FROM ubuntu:latest

RUN apt-get update

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Upstart and DBus have issues inside docker. We work around in order to install firefox.
#RUN dpkg-divert --local --rename --add /sbin/initctl && ln -s /bin/true /sbin/initctl

# Installing the environment required: xserver, xdm, flux box and ssh
RUN apt-get install -y xpra ssh pwgen firefox

# Set locale (fix the locale warnings)
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || :

# Copy the files into the container
ADD . /home/docker

ADD https://www.torproject.org/dist/torbrowser/3.6.3/tor-browser-linux64-3.6.3_en-US.tar.xz /home/docker/tor.tar.xz

EXPOSE 22
# Start xdm and ssh services.
CMD ["/bin/bash", "/home/docker/config.sh"]

