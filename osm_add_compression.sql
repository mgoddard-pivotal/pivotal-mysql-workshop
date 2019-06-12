/*
 * Tables for querying an extract of Open Street Map "Planet" dump,
 * pared down to a specific region (the UK).
 */

DROP TABLE IF EXISTS osm;
CREATE TABLE osm /* MySQL */
(
  id BIGINT PRIMARY KEY
  , date_time DATETIME
  , uid BIGINT
  , lat DOUBLE PRECISION
  , lon DOUBLE PRECISION
  , name TEXT
) ENGINE=INNODB;

-- Intermediate table, for loading
DROP TABLE IF EXISTS osm_load;
CREATE TABLE osm_load /* MySQL */
(
  id BIGINT PRIMARY KEY
  , date_time TEXT /* DATETIME */
  , uid BIGINT
  , lat DOUBLE PRECISION
  , lon DOUBLE PRECISION
  , name TEXT
) ENGINE=INNODB;

-- Load the target table, converting the date column in the process (this is why a _load table was needed)
INSERT INTO osm
SELECT id, STR_TO_DATE(date_time, '%Y-%m-%dT%H:%i:%sZ'), uid, lat, lon, name
FROM osm_load
ORDER BY id ASC;

DROP TABLE IF EXISTS osm_k_v;
CREATE TABLE osm_k_v
(
  id BIGINT
  , k VARCHAR(64)
  , v VARCHAR(512)
  , FOREIGN KEY (id) REFERENCES osm(id) ON DELETE CASCADE
) ENGINE=INNODB;

CREATE INDEX osm_k_idx ON osm_k_v(k);
CREATE INDEX osm_v_idx ON osm_k_v(v);
CREATE INDEX osm_lat ON osm(lat);
CREATE INDEX osm_lon ON osm(lon);

-- Add compression?
ALTER TABLE osm_k_v COMPRESSION="lz4";
OPTIMIZE TABLE osm_k_v;

