# Setup monitoring on a your server using prometheus/node-exporter/promtail/loki/grafana/portainer

1. Clone this repository to the location you want.
2. Copy `.env_template` to `.env` and add the required changes sample command: `cp .env_template .env`
3. Modify .env as required. Under `COMPOSE_FILE` you can set the services you need deployed. By default its all of them. If you need to remove any of them, just remove its corresponding yml file from list. i.e to remove portainer, them remove `portainer.yml` from the list. Remember to remove the `:`(full collon) separator also.
4. Run `docker-compose up -d` to start all services. 
5. Access grafana from the IP of machine and port 3000.

## NB
- It is recommended that when running grafana, also run `prometheus-metrics.yml` and `loki-logs.yml` and `promtail-logs.yml`. Otherwise you need to login to grafana and change the prometheus and Loki datasource URLs as required.
- You can setup prometheus with remote write to another prometheus/mimir/thanos creating a `custom-prom.yml` file under prometheus directory. Sample in same folder.
- You can setup promtail with remote write to another loki creating a `custom-lokiurl.yml` file under prometheus directory. Sample in same folder.

---

### NB: Grafana domain access
If you want domain access enabled, modify .env file and add domain in place of localhost. Example below

```bash
GRAFANA_DOMAIN=mydomain.com
GRAFANA_ADMIN_USER=myadmin
GRAFANA_ADMIN_PASSWORD=myadmin
```

### NB: Portainer access
If you want to access portainer using ssl, you need to modify port exposed to `9443` from `9000`


## NOTE

For promtail to pick up container logs, you will need to run the container using `json-file` docker driver.

You can set docker to use this driver automatically for all started containers by adding the configuration below to `/etc/docker/daemon.json` file:

```json
{
    "log-driver": "json-file",
    "log-opts": {
        "tag": "{{.ImageName}}|{{.Name}}|{{.ImageFullID}}|{{.FullID}}"
    }
}
```

If you are using docker compose add the following to the top of the compose file.

````yaml
x-logging: &logging
  logging:
    driver: 'json-file'
    options: 
      tag: '{{.ImageName}}|{{.Name}}|{{.ImageFullID}}|{{.FullID}}'

````

Then for each service in your compose file you can use this logging method. This is good to avoid duplication:

```yaml
services:
  grafana:
    <<: *logging
    image: grafana/grafana:latest
    container_name: grafana
    #.........other options for the service
```

If you are running a container manually using docker run command specify the log options like below. 

`docker run -d --name randomlogger --log-driver json-file --log-opt tag="{{.ImageName}}|{{.Name}}|{{.ImageFullID}}|{{.FullID}}" chentex/random-logger:latest 100 400`

This will run a random log generator generating logs randomly one for each time between 100 and 400 milliseconds. Read more about random log image from the owners github page
[https://github.com/chentex/random-logger](https://github.com/chentex/random-logger)
