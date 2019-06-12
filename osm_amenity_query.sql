select v, count(*)
from osm_k_v
where k = 'amenity'
group by 1
order by 2 desc
limit 30;

