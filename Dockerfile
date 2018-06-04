FROM ubuntu:latest
MAINTAINER Beth Anderson <beth.anderson@bbc.co.uk>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y python3 python3-pip python3-venv

# Setup Python and Gunicorn
RUN python3 -m venv /venv
RUN /venv/bin/pip3 install --upgrade pip gunicorn

# Setup flask application
RUN mkdir -p /deploy/app
COPY gunicorn_config.py /deploy/gunicorn_config.py
COPY app /deploy/app
RUN /venv/bin/pip3 install -r /deploy/app/requirements.txt

# Set working directory
WORKDIR /deploy/app

EXPOSE 5000

# Start gunicorn
CMD ["/venv/bin/gunicorn", "--config", "/deploy/gunicorn_config.py", "hello:app"]
