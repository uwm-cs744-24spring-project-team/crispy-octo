# Colocation: Evaluation of Overcommitting Batch Jobs in Cluster

> UW-Madison CS 744 Big Data System Spring 2024 Project


## Folder Structure 

- terraform: configuration of the cluster.
- terraform/helm: helm applications, including koordinator and spark operator.
- k8s: kubernetes cluster configuration for running spark jobs and configuring namespace for koordinator.
- expr: experiments settings and scripts.
- output: stdout of running experiments.

## How to Run

### Prerequisition

- Install Terraform, Helm and Google Cloud CLI and follow their authorization tutorials.
- make

### Run

1. start cluster: `make start`
2. run experiment: `make -b expr NAME=<expr folder name>`
3. proxy spark ui: `make pf_def` for default namespace, `make pf_col` for colocation namespace.
4. print node usage: `make node_print_usage`
5. stop experiment: `make -b expr_stop NAME=<expr folder name>`
6. destroy cluster: `make destroy_cluster`

## Author

Mondo Jiang, Zihao Zhu

2024
