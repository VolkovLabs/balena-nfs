FROM nginx:stable-alpine

## NFS
ENV NFS_HOST=localhost
ENV NFS_HOST_MOUNT=/
ENV NFS_MOUNT_POINT=/mnt/nvme
ENV NFS_VERSION=nfs

## Grafana
ENV GRAFANA_HOST=localhost
ENV GRAFANA_PORT=3000
ENV GRAFANA_SSL=/C=US/ST=Florida/L=Tampa/O=Volkov Labs/OU=Technology/CN=localhost/

## Generate certificate
RUN apk add --update openssl && \
    rm -rf /var/cache/apk/*
RUN openssl req -x509 -out /etc/nginx/ssl.crt -keyout /etc/nginx/ssl.key -newkey rsa:4096 -nodes -sha256 -subj ${GRAFANA_SSL}
    
## Copy configuration
COPY default.conf /etc/nginx/templates/default.conf.template
COPY proxy.conf /etc/nginx/conf.d/proxy.conf
COPY http_headers.conf /etc/nginx/conf.d/http_headers.conf

## NFS
RUN apk add nfs-utils

## Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
