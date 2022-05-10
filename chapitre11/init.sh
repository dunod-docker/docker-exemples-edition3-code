#!/bin/sh
sudo yum install -y net-tools
sudo yum install -y git
sudo yum install -y nmap
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo 
sudo yum install -y docker-ce-20.10.12-3.el8
sudo systemctl start docker
sudo systemctl enable docker
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install nomad
sudo yum install -y dos2unix
cat > Dockerfile <<- EOM
FROM python:3.10.1-slim-bullseye

WORKDIR /app

RUN pip3 install Flask
RUN pip3 install requests

COPY app.py app.py

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
EOM
cat > app.py <<- EOM
from flask import Flask
import uuid
import requests
import os

app = Flask(__name__)
unique_id = uuid.uuid4()
hit_count = 0

def get_nom():
    if os.path.isfile('/mon_nom'):
      with open('/mon_nom') as f:
        s = f.read()
        return s
    else:
        return "Inconnu"


@app.route('/')
def hello_world():
    global hit_count
    hit_count = hit_count + 1
    return "Hello, voici mon identifiant unique [{}] et le nombre de hit que j'ai compté [{}]".format(unique_id, hit_count)


@app.route('/appel_back')
def hello_service_central():
    s = hello_world()
    r = requests.get('http://hello-back:5000/')
    return "<h2>Service hello-front</h2>{}<br/><h2>Service hello-back</h2>{}".format(s,r.text)


@app.route('/nom')
def hello_nom():
    return "Hello je suis <b>{}</b>".format(get_nom())


EOM
sudo docker build -t flask-app .
sudo docker tag flask-app:latest flask-app:local
rm -f Dockerfile
rm -f app.py
