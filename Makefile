# This is only a set of shortcuts, you can also run the ansible-playbook command directly
update:
	ansible-galaxy role install -r requirements.yml
	ansible-galaxy collection install -r requirements.yml

stage: staging
stage-common: staging-common
staging: 
	ansible-playbook -i hosts/staging site.yml -D -v -K
staging-common:
	ansible-playbook -i hosts/staging site.yml -D -v -K -t common
production:
	ansible-playbook -i hosts/production site.yml -D -v -K

staging-dry:
	ansible-playbook -i hosts/staging site.yml -D -v -K -C
production-dry:
	ansible-playbook -i hosts/production site.yml -D -v -K -C

download-staging:
	ansible-playbook -i hosts/staging download.yml -K
download-production:
	ansible-playbook -i hosts/production download.yml -K
download-hometown:
	ansible-playbook -i hosts/production download.yml -K -t hometown

deploy-hometown-staging:
	ansible-playbook -i hosts/staging deploy.yml -D -v -t hometown
deploy-hometown-production:
	ansible-playbook -i hosts/production deploy.yml -D -v -t hometown

restart-staging:
	ansible-playbook -i hosts/staging restart.yml -D -v
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
