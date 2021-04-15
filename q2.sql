DROP VIEW IF EXISTS parlgov.AllCabinet20 CASCADE

CREATE VIEW parlgov.AllCabinet20 AS (
SELECT *
FROM parlgov.cabinet
WHERE start_date >= '2001-01-01'
);

SELECT *
FROM parlgov.AllCabinet20;