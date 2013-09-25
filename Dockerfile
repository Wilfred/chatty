FROM ubuntu
MAINTAINER Wilfred Hughes me@wilfred.me.uk

# Update the Ubuntu packages lists
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

# Get our install dependencies
RUN apt-get install -y ghc cabal-install

# Get dependencies for keeping the process running
RUN apt-get install -y supervisor

# set up git
RUN apt-get install -y git
RUN mkdir -p ~/.ssh
RUN ssh-keyscan -t rsa,dsa github.com >> ~/.ssh/known_hosts

# grab the code
RUN mkdir /opt/chatty
RUN git clone https://github.com/Wilfred/chatty.git /opt/chatty

# Build the code.
RUN cabal update
RUN apt-get install zlib1g-dev # required to build one our dependencies
RUN cabal install /opt/chatty --user
RUN mkdir /opt/chatty/log

# Run the code!
RUN cp /opt/chatty/chatty.conf /etc/supervisor/conf.d/
ENTRYPOINT cd /opt/chatty && /.cabal/bin/chatty -p 80
EXPOSE 80