Here in this Demo we are not setting up the default values for the variables in the tfvars files. However we are using environment variables to be set at the command prompt using
below commands: 

Setting up the instance_type varible using below command
$ export TF_VAR_instance_type=t2.micro


Setting up the ami varible using below command
$ export TF_VAR_ami=ami-087c17d1fe0178315
