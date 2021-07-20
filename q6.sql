DROP VIEW IF EXISTS AllPositions CASCADE;
DROP VIEW IF EXISTS PositionsType CASCADE;
DROP TABLE IF EXISTS parlgov.q5 CASCADE;

CREATE VIEW AllPositions AS (
SELECT t3.name AS countryName, t1.party_id, t1.left_right
FROM party_position AS t1, party AS t2, country AS t3
WHERE t1.party_id = t2.id AND t2.country_id = t3.id
);

CREATE VIEW PositionsType AS (
SELECT countryName, party_id, left_right,
    CASE WHEN left_right > 0 AND left_right <= 2 THEN 1 END AS r0_2,
    CASE WHEN left_right > 2 AND left_right <= 4 THEN 1 END AS r2_4,
    CASE WHEN left_right > 4 AND left_right <= 6 THEN 1 END AS r4_6,
    CASE WHEN left_right > 6 AND left_right <= 8 THEN 1 END AS r6_8,
    CASE WHEN left_right > 8 AND left_right <= 10 THEN 1 END AS r8_10
FROM AllPositions
);

CREATE TABLE parlgov.q6
AS
SELECT countryName,
COUNT(r0_2) AS "r0-2",
COUNT(r2_4) AS "r2-4",
COUNT(r4_6) AS "r4-6",
COUNT(r6_8) AS "r6-8",
COUNT(r8_10) AS "r8-10"
FROM PositionsType
GROUP BY countryName;