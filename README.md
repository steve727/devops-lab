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
### DevOps Monitoring Deep Dive (Ubuntu 20.04.03)

Example Vagrantfile to spin up an Ubuntu server:
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

Install Docker and related packages:
```bash
sudo apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add
 sudo apt-key fingerprint 0EBFCD88
 sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
 sudo apt-get install docker-ce
```
