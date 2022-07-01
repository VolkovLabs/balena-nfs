FROM timescale/timescaledb:2.4.2-pg13

## Environment
ENV TIMESCALEDB_TELEMETRY=off
ENV POSTGRES_PASSWORD=postgres
ENV UDEV=1

## NFS Server
RUN apk update && apk add nfs-utils openrc
RUN rc-update add nfs

## Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["postgres"]
