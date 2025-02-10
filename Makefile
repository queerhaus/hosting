# This is only a set of shortcuts, you can also run the ansible-playbook command directly

# bitwarden-cli fails with deprecation error https://github.com/bitwarden/clients/issues/6689
export NODE_OPTIONS="--no-deprecation"

.PHONY: setup galaxy hosts
setup: galaxy hosts

galaxy:
	ansible-galaxy role install -r requirements.yml
	ansible-galaxy collection install -r requirements.yml

hosts:
	ansible-playbook -i hosts/production playbooks/known-hosts.yml -D

staging:
	ansible-playbook -i hosts/staging site.yml -D -K
staging-traefik:
	ansible-playbook -i hosts/staging site.yml -D -v -K -t 'basic,traefik'

production:
	ansible-playbook -i hosts/production site.yml --diff --ask-become-pass
production-traefik:
	ansible-playbook -i hosts/production site.yml -D -v -K -t 'basic,traefik'
production-collective:
	ansible-playbook -i hosts/production site.yml -D -v -K -t collective

staging-dry:
	ansible-playbook -i hosts/staging site.yml -D -v -K -C
production-dry:
	ansible-playbook -i hosts/production site.yml -D -v -K -C

backup-production:
	ansible-playbook -i hosts/production playbooks/backup-download.yml -K
restore-staging:
	ansible-playbook -i hosts/staging playbooks/backup-restore.yml -K -v -D

deploy-production:
	ansible-playbook -i hosts/production playbooks/deploy.yml -D -v

restart-staging:
	ansible-playbook -i hosts/staging playbooks/restart.yml -D -v

restart-production:
	ansible-playbook -i hosts/production playbooks/restart.yml -D -v
