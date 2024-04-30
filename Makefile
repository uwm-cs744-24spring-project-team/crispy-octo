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
	kubectl apply -f k8s/koordinator-ns.yaml
	kubectl apply -f k8s/spark-operator-role-binding.yaml

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

node_pending:
	@echo 
	@echo Pending Pods
	@kubectl get pods --all-namespaces --field-selector=status.phase==Pending


top: node_print_usage ns_print_allocated ns_ko_print_allocated node_pending

.phony: expr _expr

expr:
	@mkdir -p output/$(NAME)
	@make _expr NAME=$(NAME) > output/$(NAME)/std.txt 2>&1
_expr: top
	@echo
	@echo === $(NAME) ===
	@echo

	@cd ./expr/$(NAME)/; ./start.sh
	@sleep 30

	@echo
	@echo === $(NAME) end ===
	@echo
	@make top

expr_stop:
	@cd ./expr/$(NAME)/; ./stop.sh

pf_col:
	kubectl port-forward svc/spark-ui-svc 4040:4040 -n colocation
pf_def:
	kubectl port-forward svc/spark-ui-svg 4040:4040 

remove_taint:
	kubectl taint nodes --all node.kubernetes.io/disk-pressure:NoSchedule-
