# qems-prod
Query Exporter Metric Service for Prod Environment (based on [query-exporter-metric-service](https://github.com/MamaMoney/query-exporter-metric-service) repo).

## How it works

The `config/{env}/config.yaml.tmpl` defines your datasources:

```
databases:
  db1:
    dsn: DATABASE_TYPE://DATABASE_USER:DATABASE_PASSWORD@DATABASE_HOSTNAME:DATABASE_PORT/DATABASE_NAME
    keep-connected: false
    labels:
      lblservice: QUERY_SERVICE_LABEL
      lbldatabase: QUERY_DATABASE_LABEL
```

Which will be replaced by the `boot.sh` script, replaces SSM parameter values defined in your taskdef.json for your ECS service.

The metrics definition, is what you want to convert DB data to Prometheus queries, as example in `config/qa-trx/metrics-config.yaml` :

```
metrics:
  total_number_of_processes:
    type: gauge
    description: the total number of processes running on the database
    labels: [user, command]

queries:
  query1:
    interval: 15
    databases: [db1]
    metrics: [total_number_of_processes]
    sql: SELECT user, command, count(*) AS total_number_of_processes FROM information_schema.PROCESSLIST GROUP BY user
```

The queries section references the database and produces the response of the sql query to the prometheus metric defined by the metrics section, as the query:

```
SELECT user, command, count(*) AS total_number_of_processes FROM information_schema.PROCESSLIST GROUP BY user
```

Will return the result to the metric `total_number_of_processes{}` and include the column results as labels and the metric value as value, as example:

```
# TYPE total_number_of_processes gauge
total_number_of_processes{command="Sleep",database="db1",lbldatabase="mmeu",lblservice="gretchen-qa-trx",user="admin"} 8.0
total_number_of_processes{command="Sleep",database="db1",lbldatabase="mmeu",lblservice="gretchen-qa-trx",user="mama"} 22.0
```
