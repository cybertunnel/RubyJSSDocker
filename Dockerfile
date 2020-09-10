FROM ruby:2.7.1-slim-buster

COPY ./ruby-jss-1.3.3.gem /tmp/ruby-jss-1.3.3.gem

RUN gem install /tmp/ruby-jss-1.3.3.gem 
#RUN apt-get -y update \
#    && apt-get -y upgrade \
#    && apt-get -y install rsync

RUN apt-get -y install git