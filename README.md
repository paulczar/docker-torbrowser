# Tor Browser - Docker Project #

The purpose of this project is to provide an ephemeral image for anonymous web browsing.

the docker image ( paulczar/torbrowser ) contains the [Tor Browser Bundle](https://www.torproject.org/projects/torbrowser.html.en)  which is a bundled version of firefox that connects through and uses the Tor network for anonymous web browsing.    It is accessed via some SSH forwarding magic.

# Build from Dockerfile #

```
git clone https://github.com/paulczar/docker-torbrowser.git
cd docker-torbrowser
docker build .
```

# Launching the tor-browser application #

## Start / Stop Scripts ##

*Use the Start/Stop scripts provided in this repository*

`./start`

`./stop`

Start will launch the browser and provide you with the user/pass combo and the ssh command to set up the X11 forwarding.

Stop will kill and remove the docker container.


## By hand ##

```
ID=$(docker run -d paulczar/torbrowser)
PORT=$(docker port $ID 22)
docker logs $ID 2> /dev/null | head -1
ssh -oStrictHostKeyChecking=no -oCheckHostIP=no -YC -c blowfish docker@localhost -p $PORT ./tor-browser
```

Remember to kill / rm the docker when you're finished with it.

```
docker kill $ID
docker rm $ID
```

# ToDo

* Encrypt the folder that the tor browser is installed to