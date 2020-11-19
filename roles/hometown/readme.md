TODO: This is quite outdated and needs to be cleaned up

Docker setup with Traefik taken from this very detailed guide 
https://www.innoq.com/en/blog/traefik-v2-and-mastodon/

## Run mastodon setup guide
This needs to be done on any new hometown server to initialize crypto variables.
TODO: turn this into ansible thingie

```bash
touch .env.hometown
chown 991:991 .env.hometown  # do this step only on linux hosts where docker is running directly on the same host
docker-compose run --rm -v $(pwd)/.env.hometown:/opt/mastodon/.env.production town-web bundle exec rake mastodon:setup
```
postgres host: town-db
redis host: town-redis
other settings default, passwords empty

## Maintenance
Run the mastodon cli tool like this:
`docker-compose exec town-web tootctl <command>`