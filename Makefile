
tf_apply:
	cd terraform && terraform apply -auto-approve

tf_destroy:
	cd terraform && terraform destroy -auto-approve
