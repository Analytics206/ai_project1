# Services in workspace
This file lists all the services, networks, and volumes defined in the `docker-compose.yml` file, along with useful Docker commands for managing the environment.

## Services
| Service Name | Container Name | Port Address | Access URL |
|--------------|----------------|--------------|------------|

## Networks
| Network Name |
|--------------|

## Volumes
| Volume Name |
|-------------|

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
