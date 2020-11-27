#INCLUDE MAKEFILES
include packer-demo/Makefile

#CREATE

create_pipeline: step1

step1: create_networking create_ami create_backend create_frontend

create_networking:
		cd ./terraform-demo/networking; \
		terraform init; \
		terraform apply -auto-approve -var-file="./module.tfvars"

create_ami:
		cd ./packer-demo; \
		packer build packer.json

create_backend:
		cd ./terraform-demo/efimeros/backend; \
		terraform init; \
		terraform apply -auto-approve -var-file="./project.tfvars"

create_frontend:
		cd ./terraform-demo/efimeros/frontend; \
		terraform init; \
		terraform apply -auto-approve -var-file="./project.tfvars"; \
		sleep 30 ; \
		cd ./ansible; \
		ansible-playbook frontend.yml

#UPDATE FRONTEND

update_frontend: update_backend update_haproxy

update_backend:
		cd ./terraform-demo/efimeros/backend; \
		terraform apply -auto-approve -var-file="./project.tfvars"

update_haproxy:
		cd ./terraform-demo/efimeros/frontend; \
		terraform apply -auto-approve -var-file="./project.tfvars"; \
		cd ./ansible; \
		ansible-playbook frontend.yml --tag haproxy_template

#DESTROY

destroy_pipeline: destroy_frontend destroy_backend destroy_ami destroy_networking

destroy_frontend:
		cd ./terraform-demo/efimeros/frontend; \
		terraform init; \
		terraform destroy -auto-approve -var-file="./project.tfvars";

destroy_backend:
		cd ./terraform-demo/efimeros/backend; \
		terraform init; \
		terraform destroy -auto-approve -var-file="./project.tfvars"

destroy_ami:
		-aws ec2 deregister-image --region ${REGION} --image-id ${AMI_ID} ; \
		aws ec2 delete-snapshot --region ${REGION} --snapshot-id ${SNAPSHOT}

destroy_networking:
		cd ./terraform-demo/networking; \
		terraform init; \
		terraform destroy -auto-approve -var-file="./module.tfvars"