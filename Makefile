tf_apply:
	cd terraform && terraform apply -auto-approve

tf_apply_helm:
	gcloud container clusters get-credentials primary-zonal --region us-central1-c
	cd terraform/helm && terraform init && terraform apply -auto-approve

tf_destroy:
	cd terraform && terraform destroy -auto-approve

k8s_spark_pi:
	kubectl apply -f k8s/spark-pi.yaml

login:
	gcloud auth application-default login && gcloud container clusters get-credentials primary-zonal --region=us-central1-c
