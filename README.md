# Setup monitoring on a vps using prometheus/node-exporter/promtail/loki/grafana

Clone this repository to the location you want

Run `docker-compose up -d` to start all services. Access grafana from the IP of machine and port 3000.

If you want ssl enabled, modify docker compose by uncommenting the lines below

```
  grafana:
    <<: *logging
    image: grafana/grafana:latest
    container_name: grafana
    volumes:
      - grafana_data:/var/lib/grafana
      - ./grafana/provisioning/:/etc/grafana/provisioning/
      #- /etc/letsencrypt/live/<domain-name>/cert.pem:/ssl/cert.pem:ro
      #- /etc/letsencrypt/live/<domain-name>/privkey.pem:/ssl/privkey.pem:ro
    environment:
      #- GF_SERVER_PROTOCOL=https
      #- GF_SERVER_CERT_FILE=/ssl/cert.pem
      #- GF_SERVER_CERT_KEY=/ssl/privkey.pem
```