# Services in ai_project1
This file lists all the services, networks, and volumes defined in the `docker-compose.yml` file, along with useful Docker commands for managing the environment.

## Services
| Service Name | Container Name | Port Address | Access URL |
|--------------|----------------|--------------|------------|
| grafana | ai_project1-grafana | 3000:3000 |  |
| kafka | ai_project1-kafka | 9092:9092 |  |
| kafka_exporter | ai_project1-kafka-exporter | 7071:7071 |  |
| mongodb | ai_project1-mongodb | 27017:27017 |  |
| mongodb_exporter | ai_project1-mongodb-exporter | 9216:9216 |  |
| neo4j | ai_project1-neo4j | 7474:7474,7687:7687 |  |
| neo4j_exporter | ai_project1-neo4j-exporter | 2004:2004 |  |
| openwebui | ai_project1-openwebui | 8080:8080 |  |
| postgres | ai_project1-postgres | 5432:5432 |  |
| postgres_exporter | ai_project1-postgres-exporter | 9187:9187 |  |
| prometheus | ai_project1-prometheus | 9090:9090 |  |
| python | ai_project1-python | 8888:8888 |  |
| qdrant | ai_project1-qdrant | 6333:6333,6334:6334 |  |
| redis | ai_project1-redis | 6379:6379 |  |
| redis_exporter | ai_project1-redis-exporter | 9121:9121 |  |

## Networks
| Network Name |
|--------------|
| ai_project1-network |

## Volumes
| Volume Name |
|-------------|
| grafana-data |
| kafka-data |
| mongodb-data |
| neo4j-data |
| openwebui-data |
| postgres-data |
| prometheus-data |
| qdrant-data |
| redis-data |

## Useful Docker Commands
### Start the environment
```bash
docker compose up -d
```

### Stop the environment
```bash
docker compose down
```

### Stop and remove all containers, networks, and volumes
```bash
docker compose down --volumes
```

### View logs for a specific service
```bash
docker compose logs <service_name>
```

### Remove a specific volume
```bash
docker volume rm <volume_name>
```

### Remove a specific network
```bash
docker network rm <network_name>
```
