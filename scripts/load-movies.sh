#!/usr/bin/env bash
# Load a small movies graph into the neo4j database so the tools have data.
set -euo pipefail

docker exec -i core-1 cypher-shell \
    -u neo4j -p neo4j-password -d neo4j <<'CYPHER'
LOAD CSV WITH HEADERS FROM 'https://data.neo4j.com/importing-fundamentals/movies.csv' AS row
WITH row LIMIT 3000
MERGE (m:Movie {movieId: toInteger(row.movieId)})
SET m.title = row.title, m.released = date(row.released), m.imdbRating = toFloat(row.imdbRating);
LOAD CSV WITH HEADERS FROM 'https://data.neo4j.com/importing-fundamentals/persons.csv' AS row
MERGE (p:Person {tmdbId: toInteger(row.person_tmdbId)})
SET p.name = row.name, p.born = CASE WHEN row.born <> '' THEN date(row.born) END;
LOAD CSV FROM 'https://data.neo4j.com/importing-fundamentals/acted_in.csv' AS row
WITH row SKIP 1
MATCH (m:Movie {movieId: toInteger(row[0])})
MATCH (p:Person {tmdbId: toInteger(row[1])})
MERGE (p)-[r:ACTED_IN]->(m) SET r.role = row[2];
MATCH (m:Movie) RETURN count(m) AS movies;
CYPHER
