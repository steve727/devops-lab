## steve727's repo for testing various DevOps tools and processes

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
