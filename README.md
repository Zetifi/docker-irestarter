# Certificate refresher

A custom image that can be used in a docker-compose file to restart another service upon a specific file being updated.

Use this when a service can't recognise a refreshed SSL certificate itself.

## Example compose file
Set the file to monitor for changes as an environment variable.
This should be the SSL certificate file.
```
SSL_CERTFILE=/etc/letsencrypt/example-domain/fullchain.pem 
```

This snippet can be inserted into an existing compose file with minimal changes.
See `docker-compose.yml` for a fully functional example.
```yaml
version: "3"
services:
  certificate_refresher:
    image: zetifi-certificate-refresher:latest
    restart: always
    volumes:
      - ${SSL_CERTFILE}:${SSL_CERTFILE}
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - SSL_CERTFILE=${SSL_CERTFILE}
      # Update service name to be restarted
      - SERVICE_TO_RESTART=example_https_service

  # Ensure service name is explicit
  # We don't want to restart the wrong one
  example_https_service:
    ...
```
