FROM ubuntu:latest
MAINTAINER Nathan <r@reaby.org>

RUN apt-get update &&  apt-get install -y git && apt-get install -y ruby && gem install bundler

ENV APP_HOME /rea
ENV HOME /root
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
RUN git init && git pull https://github.com/rea-cruitment/simple-sinatra-app.git
RUN bundle install

ENV PORT 80
EXPOSE 80
CMD ["ruby","helloworld.rb","-o","0.0.0.0"]

