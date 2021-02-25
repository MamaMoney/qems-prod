FROM 658358111897.dkr.ecr.eu-west-1.amazonaws.com/prometheus-sql-query-exporter:base
ARG TARGET_ENV
ENV TARGET_ENV ${TARGET_ENV}
ADD config/${TARGET_ENV}/config.yaml.tmpl /config.yaml.tmpl
ADD config/${TARGET_ENV}/metrics-config.yaml /metrics-config.yaml
ADD boot.sh /boot.sh
RUN chmod +x /boot.sh
ENTRYPOINT ["/boot.sh"]
