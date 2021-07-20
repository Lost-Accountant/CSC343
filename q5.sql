DROP VIEW IF EXISTS AllRatios CASCADE;
DROP VIEW IF EXISTS AllAvgRatios CASCADE;
DROP TABLE IF EXISTS parlgov.q5 CASCADE;

CREATE VIEW AllRatios AS (
SELECT DATE_PART('year', e_date) AS year, id, country_id, CAST(votes_cast AS DECIMAL)/electorate AS participation
FROM parlgov.election
WHERE e_date BETWEEN TO_DATE('2001-01-01', 'YYYY-MM-DD') AND TO_DATE('2017-01-01', 'YYYY-MM-DD')
AND votes_cast IS NOT NULL
AND electorate IS NOT NULL
);


CREATE VIEW AllAvgRatios AS (
SELECT year, country_id, AVG(participation) AS participationRatio
FROM AllRatios
GROUP BY country_id, year
);

--Remove countries with participation ratio decreasing
-- No result as all countries had experienced decrease
CREATE TABLE parlgov.q5
AS
SELECT t2.name AS countryName, t1.year, t1.participationRatio
FROM AllAvgRatios AS t1, Country AS t2
WHERE t1.country_id = t2.id
AND NOT EXISTS (
SELECT *
FROM AllAvgRatios AS t1, AllAvgRatios AS t2
WHERE t1.country_id = t2.country_id
AND t1.year <= t2.year
AND t1.participationRatio > t2.participationRatio);