
tf_apply:
	cd terraform && terraform apply -auto-approve

tf_destroy:
	cd terraform && terraform destroy -auto-approve

k8s_spark_pi:
	kubectl apply -f k8s/spark-pi.yaml
