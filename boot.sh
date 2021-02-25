#!/bin/bash
cp /config.yaml.tmpl /config.yaml

DATABASE_TYPE=${DATABASE_TYPE:-none}
DATABASE_USER=${DATABASE_USER:-none}
DATABASE_PASSWORD=${DATABASE_PASSWORD:-none}
DATABASE_HOSTNAME=${DATABASE_HOSTNAME:-none}
DATABASE_PORT=${DATABASE_PORT:-3306}
DATABASE_NAME=${DATABASE_NAME:-none}
QUERY_SERVICE_LABEL=${QUERY_SERVICE_LABEL:-none}
QUERY_DATABASE_LABEL=${QUERY_DATABASE_LABEL:-none}

if [ ${DATABASE_TYPE} == "none" ] && [ ${DATABASE_HOSTNAME} == "none" ] && [ ${QUERY_SERVICE_LABEL} == "none" ] && [ ${QUERY_DATABASE_LABEL} == "none" ]
    then
      echo "missing environment variables"
      exit 1
fi

if [ ! /metrics-config.yaml ] 
    then 
      echo "metrics-config.yaml is missing"
      exit 1
fi

sed -i "s/DATABASE_TYPE/$DATABASE_TYPE/g" /config.yaml
sed -i "s/DATABASE_USER/$DATABASE_USER/g" /config.yaml
sed -i "s/DATABASE_PASSWORD/$DATABASE_PASSWORD/g" /config.yaml
sed -i "s/DATABASE_HOSTNAME/$DATABASE_HOSTNAME/g" /config.yaml
sed -i "s/DATABASE_PORT/$DATABASE_PORT/g" /config.yaml
sed -i "s/DATABASE_NAME/$DATABASE_NAME/g" /config.yaml
sed -i "s/QUERY_SERVICE_LABEL/$QUERY_SERVICE_LABEL/g" /config.yaml
sed -i "s/QUERY_DATABASE_LABEL/$QUERY_DATABASE_LABEL/g" /config.yaml

cat /metrics-config.yaml >> /config.yaml

/virtualenv/bin/query-exporter /config.yaml --host 0.0.0.0 --port 9560
