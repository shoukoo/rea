VERSION="0.0.2"

kill:
	@echo "Killing app infra"
	@cd terraform/app/ && terraform destroy --auto-approve
	@echo "Killing vpc infra"
	@cd terraform/vpc/ && terraform destroy --auto-approve
	@echo "Done!!"

apply:
	@echo "Generating ssh key pair"
	@ssh-keygen -b 2048 -t rsa -f rea -q -N ""
	@echo "Killing app infra"
	@cd terraform/app/ && terraform apply --auto-approve
	@echo "Killing vpc infra"
	@cd terraform/vpc/ && terraform apply --auto-approve
	@echo "Done!!"

build:
	@echo "build ${VERSION}"
	@docker login -u shoukoo -p ${TOKEN} docker.pkg.github.com
	@docker build -t docker.pkg.github.com/shoukoo/rea/app:${VERSION} .
	@docker push  docker.pkg.github.com/shoukoo/rea/app:${VERSION}


local:
	docker build -t foo . && docker run -p 9292:9292 foo 

