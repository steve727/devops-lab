### My DevOps repo for testing various DevOps tools & processes

[git first time setup](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup)
```bash
git config --list --show-origin
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
git config --global core.editor vim
git config --global init.defaultBranch main
git config --list
```
[docker installation on debian](https://docs.docker.com/engine/install/debian/)

[my docker notes](https://github.com/steve727/docs/blob/main/docker.md)

### [devcontainer](https://github.com/microsoft/vscode-dev-containers) build
`cat ~/repos/devops-lab/.devcontainer/devcontainer.json`

```bash
cd ~/repos/devops-lab
docker build -t steve727/devcontainer .
docker run steve727/devcontainer
docker push steve727/devcontainer
```
## DevOps Monitoring Deep Dive (Ubuntu 20.04.03)

### Example Vagrantfile to spin up an Ubuntu server:
```bash
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "app" do |app|
    app.vm.box = "bento/ubuntu-20.04"
    app.vm.hostname = "app"
    app.vm.network "private_network", ip: "192.168.50.88"
  end

end
```
### Install Docker and related packages:
```bash
sudo apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt-get install docker-ce
sudo usermod -aG docker vagrant
```

### Install nodejs
```bash
curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
sudo ./nodesource_setup.sh
sudo apt-get install -y nodejs
```
### Build app container
```bash
sudo docker build -t ft-app .
```
### Install Prometheus
```
sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v2.29.2/prometheus-2.29.2.linux-amd64.tar.gz
tar -xvf prometheus-2.29.2.linux-amd64.tar.gz
cd prometheus-2.29.2.linux-amd64/
sudo mv console* /etc/prometheus
sudo mv prometheus.yml /etc/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus
sudo mv prometheus /usr/local/bin/
sudo mv promtool /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool
sudo vim /etc/systemd/system/prometheus.service
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
sudo useradd --no-create-home --shell /bin/false alertmanager
sudo mkdir /etc/alertmanager
cd /tmp/
```
### Install alertmanager
```bash
wget https://github.com/prometheus/alertmanager/releases/download/v0.23.0/alertmanager-0.23.0.linux-amd64.tar.gz
tar -xvf alertmanager-0.23.0.linux-amd64.tar.gz
cd alertmanager-0.23.0.linux-amd64/
sudo mv alertmanager /usr/local/bin/
sudo mv amtool /usr/local/bin/
sudo chown alertmanager:alertmanager /usr/local/bin/alertmanager
sudo chown alertmanager:alertmanager /usr/local/bin/amtool
sudo mv alertmanager.yml /etc/alertmanager/
sudo chown -R alertmanager:alertmanager /etc/alertmanager/
sudo vim /etc/systemd/system/alertmanager.service
sudo systemctl stop prometheus
sudo vim /etc/prometheus/prometheus.yml

sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl status prometheus
sudo systemctl start alertmanager
sudo systemctl status alertmanager
sudo systemctl enable alertmanager
```
### [Grafana OSS](https://grafana.com/grafana/download/8.1.3?edition=oss)
```bash
sudo apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/oss/release/grafana_8.1.3_amd64.deb
sudo dpkg -i grafana_8.1.3_amd64.deb
sudo /bin/systemctl enable grafana-server
sudo /bin/systemctl start grafana-server
```
### [Node Exporter](https://github.com/prometheus/node_exporter)
```bash
sudo useradd --no-create-home --shell /bin/false node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-amd64.tar.gz
tar -xvf node_exporter-1.2.2.linux-amd64.tar.gz
cd node_exporter-1.2.2.linux-amd64
sudo mv node_exporter /usr/local/bin/
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
sudo systemctl daemon-reload
sudo systemctl start node_exporter
```

### node_exporter.service file:
```bash
[Unit]
 Description=Node Exporter
 After=network.target

 [Service]
 User=node_exporter
 Group=node_exporter
 Type=simple
 ExecStart=/usr/local/bin/node_exporter

 [Install]
 WantedBy=multi-user.target
```

### cAdvisor:
```bash
sudo docker run \
 --volume=/:/rootfs:ro \
 --volume=/var/run:/var/run:ro \
 --volume=/sys:/sys:ro \
 --volume=/var/lib/docker/:/var/lib/docker:ro \
 --volume=/dev/disk/:/dev/disk:ro \
 --publish=8000:8080 \
 --detach=true \
 --name=cadvisor \
 google/cadvisor:latest
```
### Add endpoints
```bash
docker ps
sudo vim /etc/prometheus/prometheus.yml

- job_name: 'node_exporter'
   static_configs:
   - targets: ['localhost:9100']
- job_name: 'cadvisor'
   static_configs:
   - targets: ['localhost:8000']
 ```
### Install prom-client via npm
 ```bash
  npm install prom-client --save
  ```
### vim index.js - add:
```bash
var express = require('express');
var bodyParser = require('body-parser');
var app = express();
const prom = require('prom-client');

const collectDefaultMetrics = prom.collectDefaultMetrics;
collectDefaultMetrics({ prefix: 'forethought' });

app.get('/metrics', async function (req, res) {
   res.set('Content-Type', prom.register.contentType);
   res.end(await prom.register.metrics());
 });
 ```
 
