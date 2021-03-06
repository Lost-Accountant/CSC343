SELECT t1.id AS election_id,
t3.id AS current_cabinet
FROM election AS t1, country AS t2, cabinet AS t3
WHERE t1.country_id = t2.id AND t1.id = t3.election_id
AND t2.name = 'Japan'
ORDER BY t1.e_date DESC;

-- get selected president
SELECT t1.id, t1.description, t1.comment
FROM parlgov.politician_president as t1
WHERE id = 148;

-- get all president and their comments
SELECT t1.id, t1.description, t1.comment
FROM parlgov.politician_president as t1;