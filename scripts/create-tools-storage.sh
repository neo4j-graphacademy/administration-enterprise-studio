#!/usr/bin/env bash
# Create the tools-storage database and the service account that
# Enterprise Studio uses to store dashboards and Bloom perspectives.
set -euo pipefail

docker exec -i core-1 cypher-shell \
    -u neo4j -p neo4j-password -d system <<'CYPHER'
CREATE DATABASE `tools-storage` IF NOT EXISTS
  TOPOLOGY 3 PRIMARIES 2 SECONDARIES WAIT;
CREATE USER tools_service IF NOT EXISTS
  SET PASSWORD 'tools-password' CHANGE NOT REQUIRED;
GRANT ROLE architect TO tools_service;
SHOW DATABASES YIELD name, currentStatus
  WHERE name = 'tools-storage'
  RETURN name, count(*) AS members, collect(DISTINCT currentStatus) AS status;
CYPHER
