# This is only a set of shortcuts, you can also run the ansible-playbook command directly
galaxy:
	ansible-galaxy role install -r requirements.yml
	ansible-galaxy collection install -r requirements.yml

staging: 
	ansible-playbook -i hosts/staging site.yml -D -v -K
staging-traefik:
	ansible-playbook -i hosts/staging site.yml -D -v -K -t traefik
staging-common:
	ansible-playbook -i hosts/staging site.yml -D -v -K -t common
staging-hometown: 
	ansible-playbook -i hosts/staging site.yml -D -v -K -t hometown
staging-matrix: 
	ansible-playbook -i hosts/staging site.yml -D -v -K -t matrix
staging-mobilizon: 
	ansible-playbook -i hosts/staging site.yml -D -v -K -t mobilizon
staging-peertube: 
	ansible-playbook -i hosts/staging site.yml -D -v -K -t peertube

production:
	ansible-playbook -i hosts/production site.yml -D -v -K
production-traefik:
	ansible-playbook -i hosts/production site.yml -D -v -K -t traefik
production-hometown:
	ansible-playbook -i hosts/production site.yml -D -v -K -t hometown
production-nextcloud:
	ansible-playbook -i hosts/production site.yml -D -v -K -t nextcloud

staging-dry:
	ansible-playbook -i hosts/staging site.yml -D -v -K -C
production-dry:
	ansible-playbook -i hosts/production site.yml -D -v -K -C

backup-staging:
	ansible-playbook -i hosts/staging backup-download.yml -K
backup-production:
	ansible-playbook -i hosts/production backup-download.yml -K
backup-hometown:
	ansible-playbook -i hosts/production backup-download.yml -K -t hometown

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
