#---------------------------------------------------------------------------------------
# GENERAL
#---------------------------------------------------------------------------------------

region          = "us-east-2"
instance_number = "2"

##-------------
## INSTANCE TYPE
##-------------

#ami_id        = "ami-03657b56516ab7912"
instance_type = "t2.micro"
key_name      = "backend_keypair"

##--------------
## RESOURCE TAGS
##--------------

tag_name        = "hashitalks-demo"
tag_env         = "Laboratorio"
tag_project     = "Workshops"
tag_responsable = "jpatino@summan.com"