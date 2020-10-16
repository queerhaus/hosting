These are the scripts and docker setup used for running http://queer.haus/

## Installation
To initialize a new host, run it like this on a fresh Ubuntu 18.04.
```
sh -c "$(curl -fsSL https://raw.github.com/queerhaus/hosting/master/provision.sh)"
```
**NOTE:** Script not guaranteed to work, we ran commands manually step by step.

## Deploying new mastodon container
This is the command I normally use to pull a new container image and start it.
'docker-compose pull town-web && docker-compose up -d town-web'

It doesn't always work though, often I have to restart everything to get it back up. One of these commands might resolve a broken setup. But be sure to give Mastodon enough time to actually boot up, can take a minute or so.
'docker-compose restart town-web'
'docker-compose restart traefik'
'docker-compose down && docker-compose up -d'


## Maintenance
Run the mastodon cli tool like this:
`docker-compose exec town-web tootctl <command>`

## Notes
Mastodon setup taken from this very detailed guide 
https://www.innoq.com/en/blog/traefik-v2-and-mastodon/


