
SELECT es1.id, es1.party_id, es2.party_id, es1.election_id
FROM parlgov.election_result AS es1, parlgov.election_result AS es2
WHERE es1.id = es2.alliance_id;

SELECT country_id, leader_id, follower_id, t2.id
FROM alliance, parlgov.election AS t2
WHERE alliance.election_id = t2.id;