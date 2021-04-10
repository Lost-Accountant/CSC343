DROP VIEW IF EXISTS alliance CASCADE;
DROP TABLE IF EXISTS parlgov.Q1 CASCADE;

CREATE TABLE parlgov.Q1(
countryId INTEGER,
alliedPartyId1 INTEGER,
alliedPartyId2 INTEGER,
PRIMARY KEY (countryId, alliedPartyId1, alliedPartyId2));

CREATE VIEW alliance AS (
SELECT es1.party_id AS leader_id, es2.party_id AS follower_id,
es1.election_id, e1.country_id
-- preserve election_id for future count
FROM parlgov.election_result AS es1, parlgov.election_result AS es2,
parlgov.election AS e1
WHERE es1.id = es2.alliance_id AND es1.election_id = e1.id
-- match alliance and match country for each election
);

DROP VIEW IF EXISTS numElection;
CREATE VIEW numElection AS (
SELECT country_id, COUNT(DISTINCT id) AS num_election
FROM parlgov.election
GROUP BY country_id
);
-- get number of elections per country

INSERT INTO parlgov.Q1 (countryId, alliedpartyid1, alliedpartyid2)
SELECT t1.country_id, t1.leader_id AS alliedpartyid1, t1.follower_id AS alliedpartyid2
FROM alliance AS t1, numElection AS t2
WHERE t1.country_id = t2.country_id
GROUP BY t1.country_id, t1.leader_id,t1.follower_id, t2.num_election
HAVING COUNT(DISTINCT election_id) >= 0.3 * num_election

SELECT * FROM parlgov.Q1