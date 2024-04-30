#!/usr/bin/env bash
kubectl apply -f ./application.yaml
sleep 20
kubectl apply -f ./spark.yaml
