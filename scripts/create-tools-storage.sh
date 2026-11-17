#!/usr/bin/env bash
# Create the tools-storage database and the service account that
# Enterprise Studio uses to store dashboards and Bloom perspectives,
# and grant the extra privileges that Bloom and sharing need for the
# built-in reader role.
set -euo pipefail

docker exec -i core-1 cypher-shell \
    -u neo4j -p neo4j-password -d system <<'CYPHER'
CREATE DATABASE `tools-storage` IF NOT EXISTS
  TOPOLOGY 3 PRIMARIES 2 SECONDARIES WAIT;
CREATE USER tools_service IF NOT EXISTS
  SET PASSWORD 'tools-password' CHANGE NOT REQUIRED;
GRANT ROLE architect TO tools_service;
GRANT SHOW CONSTRAINTS ON DATABASES * TO reader;
GRANT SHOW INDEXES ON DATABASES * TO reader;
GRANT SHOW ROLE ON DBMS TO reader;
GRANT SHOW USER ON DBMS TO reader;
SHOW DATABASES YIELD name, currentStatus
  WHERE name = 'tools-storage'
  RETURN name, count(*) AS members, collect(DISTINCT currentStatus) AS status;
CYPHER
