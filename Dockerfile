FROM ruby

RUN gem install ruby-jss
RUN apt-get -y install git

COPY ./rsync /usr/bin/
WORKDIR /app