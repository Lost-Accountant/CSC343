SELECT es1.id, es1.party_id, es2.party_id, es1.election_id
FROM parlgov.election_result AS es1, parlgov.election_result AS es2
WHERE es1.id = es2.alliance_id;