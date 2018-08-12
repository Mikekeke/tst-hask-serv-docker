FROM ubuntu:18.04
LABEL Name=haskell-server Version=0.0.1
RUN apt-get update; apt-get install curl -y
RUN curl -sSL https://get.haskellstack.org/ | sh
WORKDIR /my_server
ADD . /my_server
EXPOSE 3000
RUN stack build
CMD [ "stack", "exec", "webserv-exe" ]
