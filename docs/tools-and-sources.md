---
title: Tools and Sources
summary: Tools and demo sources that are required.
authors:
  - Kamesh Sampath
date: 2021-11-21
---

At the end of this chapter you will have the required tools and enviroment ready for running the demo.

## Pre-requsites

---8<--- "includes/tools.md"

## Quickstart Sources

Clone the demo sources from the GitHub respository,

```shell
git clone https://github.com/kameshsampath/gloo-edge-gitops-quickstart
cd gloo-edge-gitops-quickstart
```

For convinience, we will refer the clone demo sources folder as `$DEMO_HOME`,

```shell
export DEMO_HOME="$PWD"
```

Navigate to the project home,

```bash
cd $DEMO_HOME
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

Let us configure `poetry` to create the python3 virutalenv in the project directory `$DEMO_HOME`,

```bash
poetry config  virtualenvs.in-project true
```
