FROM ruby

RUN gem install ruby-jss
RUN apt-get -y install git

COPY ./rsync /usr/bin/
WORKDIR /app

#RUN apt-get -y update \
#    && apt-get -y upgrade \
#    && apt-get -y install apt-utils \
#    && apt-get -y install git
#RUN python3.6 -m venv /app/
#RUN pip install git2jss

#RUN /app/setup.py

#RUN /app/bin/python -m pip install -r /app/requirements.txt

#ONBUILD RUN virtualenv /env ** /env/bin/pip install -r /app/requirements.txt
#CMD ["virtualenv",  "/env", "**" , "/env/bin/pip", "install", "-r",  "/app/requirements.txt"]
#RUN virtualenv /env ** /env/bin/pip install -r /app/requirements.txt
