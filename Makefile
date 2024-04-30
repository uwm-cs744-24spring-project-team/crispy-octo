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


.phony: expr _expr

expr:
	@make _expr NAME=$(NAME) > output/$(NAME).txt
_expr: node_print_usage ns_print_allocated
	@echo
	@echo === $(NAME) ===
	@echo

	@cd ./expr/$(NAME)/; ./start.sh

	@echo
	@echo === $(NAME) end ===
	@echo
	@make node_print_usage

expr_stop:
	@cd ./expr/$(NAME)/; ./stop.sh
