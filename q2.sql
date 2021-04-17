DROP VIEW IF EXISTS parlgov.AllCabinetParty20 CASCADE
DROP VIEW IF EXISTS parlgov.reality CASCADE

CREATE VIEW parlgov.AllCabinetParty20 AS (
SELECT t1.id AS party_id, t3.id AS cabinet_id, t3.country_id AS country_id
FROM parlgov.party AS t1, parlgov.cabinet_party AS t2, parlgov.cabinet AS t3
WHERE t1.id = t2.party_id AND t2.cabinet_id = t3.id AND t3.start_date >= '2001-01-01'
)
-- select all parties that were in the cabinets that started after 2001.
-- means that the view will have all parties that were in a cabinet sometime
-- during the past 20 years

SELECT *
FROM parlgov.AllCabinetParty20

CREATE VIEW reality AS (
SELECT t1.party_id, t1.cabinet_id, t1.country_id, t2.family, t3.state_market
FROM parlgov.AllCabinetParty20 AS t1
LEFT JOIN party_family AS t2
ON t1.party_id = t2.party_id
LEFT JOIN party_position AS t3
ON t1.party_id = t3.party_id
-- group party with family and political position
);

SELECT *
FROM parlgov.reality

-- TODO: Do that planned move on note