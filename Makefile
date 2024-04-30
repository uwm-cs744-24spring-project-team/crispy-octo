start: tf_apply_cluster tf_apply_helm tf_apply_k8s

tf_apply_cluster:
	cd terraform && terraform apply -auto-approve
tf_destroy_cluster:
	cd terraform && terraform destroy -auto-approve

tf_apply_helm:
	gcloud container clusters get-credentials primary-zonal --region us-central1-c
	cd terraform/helm && terraform init && terraform apply -auto-approve
tf_destroy_helm:
	cd terraform/helm && terraform destroy -auto-approve

tf_apply_k8s:
	kubectl apply -f k8s/spark-operator-role-binding.yaml

k8s_spark_pi:
	kubectl apply -f k8s/spark-pi.yaml

login:
	gcloud auth application-default login && gcloud container clusters get-credentials primary-zonal --region=us-central1-c

node_print_usage:
	@kubectl get nodes -o jsonpath='{range .items[*]}{"Capacity"}{"\t"}{.metadata.name}{"\t"}{.status.capacity.cpu}{"\t"}{.status.capacity.memory}{"\n"}{"Allocatable"}{"\t"}{.metadata.name}{"\t"}{.status.allocatable.cpu}{"\t"}{.status.allocatable.memory}{"\n"}{end}'
	@echo "Usage" && kubectl top nodes

expr_1:

