# This is only a set of shortcuts, you can also run the ansible-playbook command directly

# bitwarden-cli fails with deprecation error https://github.com/bitwarden/clients/issues/6689
export NODE_OPTIONS="--no-deprecation"

galaxy:
	ansible-galaxy role install -r requirements.yml
	ansible-galaxy collection install -r requirements.yml

staging: 
	ansible-playbook -i hosts/staging site.yml -D -K
staging-traefik:
	ansible-playbook -i hosts/staging site.yml -D -v -K -t 'basic,traefik'
staging-hometown: 
	ansible-playbook -i hosts/staging site.yml -D -v -K -t 'basic,hometown'
staging-matrix: 
	ansible-playbook -i hosts/staging site.yml -D -v -K -t 'basic,matrix'
staging-mobilizon: 
	ansible-playbook -i hosts/staging site.yml -D -v -K -t 'basic,mobilizon'
staging-peertube: 
	ansible-playbook -i hosts/staging site.yml -D -v -K -t 'basic,peertube'

production:
	ansible-playbook -i hosts/production site.yml -D -K
production-basic:
	ansible-playbook -i hosts/production site.yml -D -v -K -t basic
production-traefik:
	ansible-playbook -i hosts/production site.yml -D -v -K -t traefik
production-hometown:
	ansible-playbook -i hosts/production site.yml -D -v -K -t hometown
production-nextcloud:
	ansible-playbook -i hosts/production site.yml -D -v -K -t nextcloud
production-codimd:
	ansible-playbook -i hosts/production site.yml -D -v -K -t codimd

staging-dry:
	ansible-playbook -i hosts/staging site.yml -D -v -K -C
production-dry:
	ansible-playbook -i hosts/production site.yml -D -v -K -C

backup-staging:
	ansible-playbook -i hosts/staging backup-download.yml -K
backup-staging-hometown:
	ansible-playbook -i hosts/staging backup-download.yml -K -v -t hometown
backup-production:
	ansible-playbook -i hosts/production backup-download.yml -K
backup-production-hometown:
	ansible-playbook -i hosts/production backup-download.yml -K -v -t hometown

restore-staging-codimd:
	ansible-playbook -i hosts/staging backup-restore.yml -K -v -D -t codimd

deploy-hometown-staging:
	ansible-playbook -i hosts/staging deploy.yml -D -v -t hometown
deploy-hometown-production:
	ansible-playbook -i hosts/production deploy.yml -D -v -t hometown

restart-staging:
	ansible-playbook -i hosts/staging restart.yml -D -v
restart-common-staging:
	ansible-playbook -i hosts/staging restart.yml -D -v -t common
restart-codimd-staging:
	ansible-playbook -i hosts/staging restart.yml -D -v -t codimd
restart-nextcloud-staging:
	ansible-playbook -i hosts/staging restart.yml -D -v -t nextcloud
restart-hometown-staging:
	ansible-playbook -i hosts/staging restart.yml -D -v -t hometown

restart-codimd-production:
	ansible-playbook -i hosts/production restart.yml -D -v -t codimd
restart-nextcloud-production:
	ansible-playbook -i hosts/production restart.yml -D -v -t nextcloud
restart-hometown-production:
	ansible-playbook -i hosts/production restart.yml -D -v -t hometown
