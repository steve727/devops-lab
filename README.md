## devops-lab repo for testing DevOps tools and processes

[git first time setup](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup)
```bash
git config --list --show-origin
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
git config --global core.editor vim
git config --global init.defaultBranch main
git config --list
```
[docker install debian](https://docs.docker.com/engine/install/debian/)

### .devcontainer
`cat ~/repos/devops-lab/.devcontainer/devcontainer.json`

```bash
cd ~/repos/devops-lab
docker build .
```


