-- Index the OSM tables
CREATE INDEX osm_k_idx ON osm_k_v(k);
CREATE INDEX osm_v_idx ON osm_k_v(v);
CREATE INDEX osm_lat ON osm(lat);
CREATE INDEX osm_lon ON osm(lon);

