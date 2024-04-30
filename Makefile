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
	@echo Allocatable
	@kubectl get nodes -o custom-columns='NAME:{.metadata.name}, CapCPU:.status.capacity.cpu, CapMem:.status.capacity.memory, AllocatableCPU:.status.allocatable.cpu, AllocatableMem:.status.allocatable.memory'
	@echo
	@echo Usage
	@kubectl top nodes
ns_print_allocated:
	@echo
	@echo Default Allocated
	@kubectl get pods -o custom-columns='NAME:.metadata.name, CPU_REQUEST:.spec.containers[*].resources.requests.cpu, MEMORY_REQUEST:.spec.containers[*].resources.requests.memory'
	@echo
ns_ko_print_allocated:
	@echo
	@echo Colocation Allocated
	@kubectl get pods -n colocation -o custom-columns='NAME:.metadata.name, CPU_REQUEST:.spec.containers[*].resources.requests.cpu, MEMORY_REQUEST:.spec.containers[*].resources.requests.memory'
	@echo



expr_1:
	@make _expr_1 > output/expr_1.txt
_expr_1: node_print_usage ns_print_allocated
	@echo
	@echo === expr_1 ===
	@echo

	@cd ./expr/1-base/; pwd

	@echo
	@echo === expr_1 end ===
	@echo
	@make node_print_usage

