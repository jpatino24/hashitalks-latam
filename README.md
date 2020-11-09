# hashitalks-latam

### Networking

cd  ./terraform-demo/networking
terraform init
terraform destroy -var-file="./module.tfvars"

### Frontend

cd  ./terraform-demo/efimeros/frontend
terraform init
terraform apply -var-file="./project.tfvars"