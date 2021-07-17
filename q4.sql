DROP VIEW IF EXISTS AllElections CASCADE;
DROP VIEW IF EXISTS AllVotes CASCADE;
DROP VIEW IF EXISTS AllPercentVote CASCADE;
DROP VIEW IF EXISTS FilteredPercentVote CASCADE;
DROP VIEW IF EXISTS AllVoteRange CASCADE;

CREATE VIEW AllElections AS (
SELECT DATE_PART('year', t2.e_date) AS election_year,
t2.country_id AS country_id, t1.party_id AS party_id,
t1.votes AS votes, t1.election_id AS election_id
FROM parlgov.election_result AS t1, parlgov.election AS t2
WHERE t1.election_id = t2.id
AND t1.votes IS NOT NULL
-- filter 1996 to 2016
AND t2.e_date BETWEEN TO_DATE('1996-01-01', 'YYYY-MM-DD')
              AND     TO_DATE('2016-12-31', 'YYYY-MM-DD')
);

CREATE VIEW AllVotes AS (
SELECT election_id, SUM(votes) AS total_votes
FROM AllElections
GROUP BY election_id
);

-- join the two above to create a percentage of vote
CREATE VIEW AllPercentVote AS (
SELECT t1.election_year, t1.country_id, t1.party_id, CAST(t1.votes AS DECIMAL)/ t2.total_votes AS percent_vote
FROM AllELections AS t1, AllVotes AS t2
WHERE t1.election_id = t2.election_id
);

-- then remove those in same year by group by and average out
CREATE VIEW FilteredPercentVote AS (
SELECT election_year, country_id, party_id, AVG(percent_vote) AS avg_percent_vote
FROM AllPercentVote
GROUP BY election_year, country_id, party_id
);

-- then figure out a way to create value based on condition
CREATE TABLE parlgov.q4
AS
SELECT t1.election_year AS year, t3.name AS countryName,
    CASE WHEN avg_percent_vote > 0 AND avg_percent_vote <= 0.05 THEN '(0-5]'
        WHEN avg_percent_vote > 0.05 AND avg_percent_vote <= 0.1 THEN '(5-10]'
        WHEN avg_percent_vote > 0.1 AND avg_percent_vote <= 0.2 THEN '(10-20]'
        WHEN avg_percent_vote > 0.2 AND avg_percent_vote <= 0.3 THEN '(20-30]'
        WHEN avg_percent_vote > 0.3 AND avg_percent_vote <= 0.4 THEN '(30-40]'
        WHEN avg_percent_vote > 0.4 THEN '(40-100]'
        END
    AS voteRange,
    t2.name_short AS partyName
FROM FilteredPercentVote AS t1, parlgov.Party AS t2, parlgov.Country AS t3
WHERE t1.party_id = t2.id AND t1.country_id = t3.id;