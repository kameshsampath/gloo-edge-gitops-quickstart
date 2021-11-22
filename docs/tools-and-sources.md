---
title: Tools and Sources
summary: Tools and demo sources that are required for this tutorial.
authors:
  - Kamesh Sampath
date: 2021-11-21
---

At the end of this chapter you will have the required tools and enviroment ready for running the demo.

## Pre-requsites

---8<--- "includes/tools.md"

!!! important
  You will need Gloo Edge Enterprise License Key to run the demo exercises. If you dont have one, get a trial license from [solo.io](https://lp.solo.io/request-trial).

## Demo Sources

Clone the demo sources from the GitHub respository,

```shell
git clone https://github.com/kameshsampath/gloo-edge-gitops-quickstart
cd gloo-edge-gitops-quickstart
```

For convinience, we will refer the clone demo sources folder as `$TUTORIAL_HOME`,

```shell
export TUTORIAL_HOME="$PWD"
```

Navigate to the project home,

```bash
cd $TUTORIAL_HOME
```

## Ensure Poetry

The project uses [poetry](https://python-poetry.org) to setup Python3 virtual environment to run ansible scripts. You can use `pipx` to install poetry like,

```bash
pipx install poetry && pipx ensurepath
```

Lets ensure `poetry` is setup correctly, running the following command should return the version of the installed `poetry` utility.

```bash
poetry --version
```

Let us configure `poetry` to create the python3 virutalenv in the project directory `$TUTORIAL_HOME`,

```bash
poetry config  virtualenvs.in-project true
```

## Ansible Environment

To create the virutal environment run the following command,

```shell
make create-venv
```

The command will instal all the required python modules in the `$TUTORIAL_HOME/.venv`.

Install the ansible roles and collections that will be used by the playbooks,

```bash
poetry run ansible-galaxy role install -r $TUTORIAL_HOME/requirements.yml
poetry run ansible-galaxy collection install -r $TUTORIAL_HOME/requirements.yml
```
