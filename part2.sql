SELECT t1.id AS election_id, DATE_PART('year', t1.e_date) AS year,
t3.id AS current_cabinet, t3.previous_cabinet_id AS previous_cabinet
FROM election AS t1, country AS t2, cabinet AS t3
WHERE t1.country_id = t2.id AND t1.id = t3.election_id
AND t2.name = 'Japan'
ORDER BY t1.e_date DESC;
