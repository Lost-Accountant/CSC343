DROP VIEW IF EXISTS WonElection CASCADE;
DROP VIEW IF EXISTS CountWon CASCADE;
DROP VIEW IF EXISTS ElectionAverage CASCADE;
DROP VIEW IF EXISTS ExcelParty CASCADE;
DROP VIEW IF EXISTS MostRecentWon CASCADE;
DROP VIEW IF EXISTS NotRecentWon CASCADE;

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

CREATE VIEW NotRecentWon AS (
SELECT t1.party_id, t1.election_id, t1.election_year
FROM WonElection AS t1, WonElection AS t2
WHERE t1.party_id = t2.party_id
AND t1.election_year < t2.election_year);

SELECT party_id, election_id, election_year
FROM WonElection
ORDER BY party_id, election_year;

SELECT * FROM NotRecentWon
ORDER BY party_id, election_year;

-- Find the latest election won for a given party
CREATE VIEW MostRecentWon AS (
SELECT party_id, election_id, election_year
FROM WonElection
EXCEPT ALL
SELECT *
FROM NotRecentWon
ORDER BY party_id, election_year
);


CREATE TABLE parlgov.q3(
countryName TEXT,
partyName TEXT,
partyFamily TEXT,
wonElections INTEGER,
mostRecentlyWonElectionId INTEGER,
election_year INTEGER
);

INSERT INTO parlgov.q3 (
SELECT t3.name AS countryName, t4.name AS partyName,
t5.family AS partyFamily, t1.won_count AS wonElections,
t2.election_id AS mostRecentlyWonElectionId,
t2.election_year AS mostRecentlyWonElectionYear
FROM ExcelParty AS t1, MostRecentWon AS t2, parlgov.Country AS t3, parlgov.party AS t4, parlgov.party_family AS t5
WHERE t1.party_id = t2.party_id
AND t1.country_id = t3.id
AND t1.party_id = t4.id
AND t1. party_id = t5.party_id)
;

SELECT * FROM parlgov.q3;