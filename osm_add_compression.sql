-- Add compression
ALTER TABLE osm_k_v COMPRESSION="lz4";
OPTIMIZE TABLE osm_k_v;

