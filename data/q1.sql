DROP TABLE IF EXISTS parlgov.Q1 CASCADE;
DROP VIEW IF EXISTS alliance CASCADE;

CREATE TABLE parlgov.Q1(
countryId INTEGER,
alliedPartyId1 INTEGER,
alliedPartyId2 INTEGER,
PRIMARY KEY (alliedPartyId1, alliedPartyId2));

CREATE VIEW alliance AS (
SELECT es1.party_id AS leader_id, es2.party_id AS follower_id,
es1.election_id, e1.country_id,
-- preserve election_id for future count
CAST(es1.party_id AS VARCHAR(10)) || CAST(es2.party_id AS VARCHAR(10)) AS pair
-- combine leader and follower as pair for later use
FROM parlgov.election_result AS es1, parlgov.election_result AS es2,
parlgov.election AS e1
WHERE es1.id = es2.alliance_id AND es1.election_id = e1.id
-- match alliance and match country for each election
);

SELECT country_id, COUNT(DISTINCT election_id)
FROM alliance
GROUP BY country_id
-- get number of elections per country