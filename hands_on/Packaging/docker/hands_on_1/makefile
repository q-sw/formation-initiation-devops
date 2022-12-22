DOCKER_ACCOUNT=""
tag=1.0

build-image:
	docker build -t ${DOCKER_ACCOUNT}/monimage:${tag} -f Dockerfile .

docker-login:
	docker login -u ${DOCKER_ACCOUNT}

push-image:
	docker push ${DOCKER_ACCOUNT}/monimage:${tag}