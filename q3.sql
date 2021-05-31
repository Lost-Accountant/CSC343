DROP VIEW IF EXISTS WonElection CASCADE;
DROP VIEW IF EXISTS CountWon CASCADE;
DROP VIEW IF EXISTS ElectionAverage CASCADE;
DROP VIEW IF EXISTS ExcelParty CASCADE;
DROP VIEW IF EXISTS MostRecentWon CASCADE;

-- elections won for every party in every nation
CREATE VIEW WonElection AS (
SELECT t1.party_id, t2.country_id, t1.election_id, DATE_PART('year', t2.e_date) AS election_year, t2.e_date as election_date
FROM parlgov.election_result AS t1, parlgov.election AS t2
WHERE t1.election_id = t2.id AND t1.seats > 0
);

CREATE VIEW CountWon AS (
SELECT party_id, country_id, COUNT(election_id) AS won_count
FROM WonElection
GROUP BY country_id, party_id
);

CREATE VIEW ElectionAverage AS (
SELECT country_id, AVG(won_count) AS avg_won
FROM CountWon
GROUP BY country_id
);

-- Select parties that won more than 3 times average
CREATE VIEW ExcelParty AS (
SELECT t1.country_id, t1.party_id, t1.won_count
FROM CountWon AS t1, ElectionAverage AS t2
WHERE t1.country_id = t2.country_id
AND t1.won_count >= 3 * avg_won
);

SELECT* FROM ExcelParty;

-- Find the latest election won for a given party
CREATE VIEW MostRecentWon AS
SELECT party_id, election_id AS mostRecentlyWonElectionId, MAX(election_year) AS mostRecentlyWonElectionYear
FROM WonElection
GROUP BY party_id, election_id
WHERE election_date IN (
-- the date selected is the most recent won one for the party
    SELECT MAX(election_date) AS mostRecentlyWonElectionYear
    FROM WonElection
    GROUP BY party_id
    )
;