CREATE VIEW alliance AS(
SELECT es1.id, es1.party_id AS leader_id, es2.party_id AS follower_id, es1.election_id
FROM parlgov.election_result AS es1, parlgov.election_result AS es2
WHERE es1.id = es2.alliance_id);

SELECT t2.country_id, leader_id, follower_id, t2.id
FROM alliance, parlgov.election AS t2
WHERE alliance.election_id = t2.id;

SELECT DISTINCT t3.name
FROM alliance, parlgov.election AS t2, parlgov.country AS t3
WHERE alliance.election_id = t2.id AND t2.country_id = t3.id;
-- can see that only 3 countries have those alliance stuff.