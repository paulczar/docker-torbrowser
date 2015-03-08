FROM ubuntu:latest

RUN apt-get update && true

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y firefox

# Set locale (fix the locale warnings)
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || :

# Copy the files into the container
# bug in docker messes up permissions of directories unless you do this first
ADD . /home/docker

ADD https://dist.torproject.org/torbrowser/4.0.4/tor-browser-linux64-4.0.4_en-US.tar.xz /home/docker/tor.tar.xz

RUN useradd -m -d /home/docker docker

RUN cd /home/docker && tar xJf /home/docker/tor.tar.xz 

USER docker

CMD ["/home/docker/tor-browser_en-US/start-tor-browser"]
