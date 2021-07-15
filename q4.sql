DROP VIEW IF EXISTS AllElections CASCADE;
DROP VIEW IF EXISTS AllVotes CASCADE;

CREATE VIEW AllElections AS (
SELECT DATE_PART('year', t2.e_date) AS election_year,
t2.country_id AS country_id, t1.party_id AS party_id,
t1.votes AS votes, t1.election_id AS election_id
FROM parlgov.election_result AS t1, parlgov.election AS t2
WHERE t1.election_id = t2.id
);

SELECT * FROM AllElections;

CREATE VIEW AllVotes AS (
SELECT election_id, SUM(votes) AS total_votes
FROM AllElections
GROUP BY election_id
);

SELECT * FROM AllVotes;

-- join the two above to create a percentage of vote
-- then remove those in same year by group by and average out

-- then figure out a way to create value based on condition