FROM ruby:2.7.1-buster

RUN gem install ruby-jss
RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install rsync

RUN apt-get -y install git
