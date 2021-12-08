---
title: Envrionment Cleanup
summary: Delete the minikube and other resources.
authors:
  - Kamesh Sampath
date: 2021-10-02
---

At the end of this chapter you would have,

- [x] Delete the minikibe resources

## Ensure Environment

Navigate to Tutorial home

```bash
cd $DEMO_HOME
```

Set cluster environment variables

---8<--- "includes/env.md"

## Minikube Clean up

```bash
make clean-up
```
