# Setup monitoring on a vps using prometheus/node-exporter/promtail/loki/grafana

1. Clone this repository to the location you want.
2. Copy .env_template to .env and add the required changes sample command: `cp .env_template .env`
3. Run `docker-compose up -d` to start all services. 
4. Access grafana from the IP of machine and port 3000.

### NB: Grafana domain access
If you want domain access enabled, modify .env file and add domain in place of localhost. Example below

```bash
GRAFANA_DOMAIN=mydomain.com
GRAFANA_ADMIN_USER=myadmin
GRAFANA_ADMIN_PASSWORD=myadmin
```

### NB: Portainer access
If you want to access portainer using ssl, you need to uncomment the ports mapping as required. See below section
```bash
    -----
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data
    ports:
      # - 8000:8000
      # - 9443:9443
      - 9000:9000
```

### NB: Node exporter/Loki/Promtail/Prometheus
Incase you need to be able to access them, uncomment respective ports mapping section. They are already accessible inside the grafana using docker network DNS thus no need to expose to localhost.

## NOTE

For the docker compose stack to pickup containers running in docker, you will need to run the container using `json-file` docker driver.

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
