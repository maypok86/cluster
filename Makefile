.PHONY: authorize
authorize:
	ansible-playbook -i hosts.yml authorize.yml --ask-pass

.PHONY: upgrade
upgrade:
	ansible-playbook -i hosts.yml upgrade.yml

.PHONY: cluster
cluster:
	ansible-playbook -i hosts.yml cluster.yml