FROM percona/mongodb_exporter:2.35.0 as mongodb_exporter

FROM alpine
USER root

COPY --from=mongodb_exporter /mongodb_exporter /
COPY --from=mongodb_exporter /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

EXPOSE 9216
ENTRYPOINT ["/mongodb_exporter"]