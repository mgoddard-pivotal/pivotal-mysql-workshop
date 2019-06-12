#!/bin/bash

# Fill in these values based on the contents of your service key and the host you
# used to start the SSH tunnel from.
export MYSQL_PWD="y3ntlbym9c1z1dyx"
db="service_instance_db"
user="98d0c215c22942138a8ae22ebbfadceb"
db_host="192.168.1.4"
port=13306

# The remaining values are ok as they are.
osm_url="https://s3.amazonaws.com/goddard.datasets/osm.csv.gz"
osm_kv_url="https://s3.amazonaws.com/goddard.datasets/osm_k_v.csv.gz"

# Load the osm_load table.
curl $osm_url | zcat - | mysql --local-infile=1 -h $db_host -P $port -u $user $db \
  -e "LOAD DATA LOCAL INFILE '/dev/stdin' INTO TABLE osm_load FIELDS TERMINATED BY ',';"

# Load the osm table from that landing table.
cat <<EndOfSQL | mysql -h $db_host -P $port -u $user $db
INSERT INTO osm
SELECT id, STR_TO_DATE(date_time, '%Y-%m-%dT%H:%i:%sZ'), uid, lat, lon, name
FROM osm_load
ORDER BY id ASC;
EndOfSQL

# Drop that load table.
echo "DROP TABLE osm_load;" | mysql -h $db_host -P $port -u $user $db

# Load the osm_k_v table.
curl $osm_kv_url | zcat - | mysql --local-infile=1 -h $db_host -P $port -u $user $db \
  -e "LOAD DATA LOCAL INFILE '/dev/stdin' INTO TABLE osm_k_v FIELDS TERMINATED BY ',';"

