FROM quay.io/oliver006/redis_exporter:latest as redis_exporter

FROM alpine
USER root

COPY --from=redis_exporter /redis_exporter /
COPY --from=redis_exporter /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

EXPOSE 9212
ENTRYPOINT ["/redis_exporter"]