local:
	docker build -t foo . && docker run -p 9292:9292 foo 

kill:
	@echo "Killing app infra"
	@cd terraform/app/ && terraform destroy --auto-approve
	@echo "Killing vpc infra"
	@cd terraform/vpc/ && terraform destroy --auto-approve
	@rm rea && rm rea.pub
	@echo "Done!!"

apply:
	@./check.sh
	@echo "Generating ssh key pair"
	@ssh-keygen -b 2048 -t rsa -f rea -q -N ""
	@echo "Applying vpcinfra"
	@cd terraform/vpc/ && terraform apply --auto-approve
	@echo "Applying app infra"
	@cd terraform/app/ && terraform apply --auto-approve
	@echo "Done!!"

.PHONY: local kill apply
