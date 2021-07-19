DROP VIEW IF EXISTS AllRatios CASCADE;
DROP VIEW IF EXISTS AllAvgRatios CASCADE;

CREATE VIEW AllRatios AS (
SELECT DATE_PART('year', e_date) AS year, id, country_id, CAST(votes_cast AS DECIMAL)/electorate AS participation
FROM parlgov.election
WHERE e_date BETWEEN TO_DATE('2001-01-01', 'YYYY-MM-DD') AND TO_DATE('2017-01-01', 'YYYY-MM-DD')
AND votes_cast IS NOT NULL
AND electorate IS NOT NULL
);

SELECT * FROM AllRatios;

CREATE VIEW AllAvgRatios AS (
SELECT year, country_id, AVG(participation) AS participationRatio
FROM AllRatios
GROUP BY country_id, year
);

