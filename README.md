# Administration: Neo4j Enterprise Studio with Docker

Supporting repository for the GraphAcademy lab
[Neo4j Enterprise Studio with Docker](https://graphacademy.neo4j.com/courses/administration-enterprise-studio/).

| Path | Purpose |
|---|---|
| `cluster/docker-compose.yml` | Five-member Neo4j cluster: 3 primaries, 2 secondaries |
| `studio/docker-compose.yml` | Enterprise Studio, joined to the cluster network |
| `studio/config.yaml` | Studio configuration |
| `studio/licenses/` | Put your `nes.license` file here (optional) |
| `scripts/wait-for-cluster.sh` | Wait until all five servers are Enabled |
| `scripts/create-tools-storage.sh` | Create `tools-storage` and the `tools_service` account |
| `scripts/load-movies.sh` | Load a movies graph into the `neo4j` database |

Start the cluster first, then Studio:

```bash
docker compose -f cluster/docker-compose.yml up -d
bash scripts/wait-for-cluster.sh
bash scripts/create-tools-storage.sh
docker compose -f studio/docker-compose.yml up -d
```

Studio runs without a license for evaluation and shows a banner. To remove it,
copy your license to `studio/licenses/nes.license` and restart Studio.
The credentials in these files are for local demos only.
