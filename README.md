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

## Codespaces caveat

Studio's `directClientQuery` makes the **browser** open a Bolt connection to `publicUri`, which is `bolt://localhost:17687` in `studio/config.yaml`. That address only works when the browser and Docker run on the same machine. In a browser-based Codespace the browser runs on your own machine, and Codespaces exposes each forwarded port at its own HTTPS address instead:

```text
https://<CODESPACE_NAME>-<port>.<GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN>
```

The lab lessons do not cover this, because it is a Codespaces limitation and not part of Studio. If Query or Bloom cannot connect, use one of these:

- **Proxy mode (recommended).** In `studio/config.yaml`, set the deployment `uri` to `http://core-1:7474` and remove the `directClientQuery` block. The Studio server then reaches Neo4j on the Docker network, and the browser only needs port 8080. Tested locally: reads and writes work through it, including when `core-1` is a follower. Not yet tested in a Codespace. On a cluster, proxy mode needs session affinity, which a single member address provides.
- **Direct mode with the forwarded address.** Point `publicUri` at the forwarded address of port 17687 from the pattern above, on port 443. The `workshop-agent-memory-ts` repo takes this approach for the Neo4j Browser, setting `NEO4J_server_bolt_advertised__address` to `:443` and building its link from `CODESPACE_NAME` in a post-create script. This has not been tried with Studio.

