SHELL := /bin/bash

.PHONY: authorize
authorize:
	ansible-playbook -i hosts.yml authorize.yml --ask-pass

.PHONY: authorize
authorize-deploy:
	ansible-playbook -i hosts.yml authorize-deploy.yml

.PHONY: upgrade
upgrade:
	ansible-playbook -i hosts.yml upgrade.yml

.PHONY: cluster
cluster:
	ansible-playbook -i hosts.yml cluster.yml

.PHONY: deploy
deploy:
	cd traefik && bash deploy.sh ${HOST} ${PORT} && cd ..
	cd cron && bash deploy.sh ${HOST} ${PORT} && cd ..

.PHONY: build
build: build-redis

.PHONY: build-redis
build-redis:
	docker --log-level=debug build --pull -f docker/production/redis/Dockerfile -t ${REGISTRY}/cluster-redis:${IMAGE_TAG} docker/production/redis

.PHONY: push
push: push-redis

.PHONY: push-redis
push-redis:
	docker push ${REGISTRY}/cluster-redis:${IMAGE_TAG}
