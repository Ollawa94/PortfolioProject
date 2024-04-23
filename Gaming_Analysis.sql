create database Gaming_Analysis;
Use Gaming_Analysis;


alter table pd modify L1_Status varchar(30);
alter table pd modify L2_Status varchar(30);
alter table pd modify P_ID int primary key;
alter table pd drop myunknowncolumn;

alter table ld drop myunknowncolumn;
alter table ld change timestamp start_datetime datetime;
alter table ld modify Dev_Id varchar(10);
alter table ld modify Difficulty varchar(15);
alter table ld add primary key(P_ID,Dev_id,start_datetime);

-- Viewing the Tables

Select *
From Ld;

Select *
From Pd;

-- Extract P_ID, Dev_ID, PName, and Difficulty_level` of all players at Level 0.


Select a.P_ID, a.Dev_ID, b.PName, a.difficulty
From Ld a
join Pd b
ON a.P_ID = b.P_ID
Where Level = 0;

-- Find `Level1_code`wise average `Kill_Count` where `lives_earned` is 2, and at least 3

Select b.L1_code, AVG(kill_count) AS avg_kill_count
From Ld a
Join Pd b
ON a.P_ID = b.P_ID
Where Lives_earned = 2
AND Stages_crossed >= 3
Group By
L1_code;

-- Find the total number of stages crossed at each difficulty level for
-- Level 2 with players using `zm_series` devices. Arrange the result
-- in decreasing order of the total number of stages crossed.

Select SUM(stages_crossed) AS total_stages_crossed, difficulty
From Ld a
Where Level = 2 AND Dev_ID like 'zm%'
Group By Difficulty
Order By total_stages_crossed DESC;

-- Extract `P_ID` and the total number of unique dates for those players
-- who have played games on multiple days.

Select P_ID, COUNT(DISTINCT start_datetime) AS unique_dates
FROM Ld
Group By P_ID
Having COUNT(Distinct start_datetime) > 1;

-- Find `P_ID` and levelwise sum of `kill_counts` where `kill_count`
-- is greater than the average kill count for Medium difficulty.

Select P_ID, Level, SUM(kill_count) AS total_kill_count
From Ld
Where kill_count > (select AVG(kill_count)
                    From Ld
                    Where Difficulty = 'Medium')
Group by P_id, level;

-- Find `Level` and its corresponding `Level_code`wise sum of lives earned,
-- excluding Level 0. Arrange in ascending order of level.

Select level, coalesce(L1_code, L2_code) AS Level_code,
	SUM(lives_earned) AS total_lives_earned
From Ld a
Join Pd b
ON a.P_ID = b.P_ID
Where Level <> 0
Group By level, L1_code, L2_code
Order By Level ASC;

 -- Find the top 3 scores based on each `Dev_ID` and
 -- rank them in increasing order using `Row_Number`.
 -- Display the difficulty as well.      
 
 
Select score, dev_id, row_number()
Over(Partition by dev_id order by score) AS rownumber, difficulty
From Ld
Group by dev_id, score, difficulty
Limit 3;

-- Find the `first_login` datetime for each device ID.

select MIN(start_datetime) AS first_login_datetime, dev_id
From Ld
Group By
Dev_ID;

-- Find the top 5 scores based on each difficulty level
-- and rank them in increasing order
-- using `Rank`. Display `Dev_ID` as well.

select score, difficulty, dev_id, RANK() OVER(partition by dev_id
Order by score) as 'RANK'
From Ld
Limit 5;

-- Find the device ID that is first logged in (based on `start_datetime`)
-- for each player (`P_ID`). Output should contain player ID,
-- device ID, and first login datetime.

select p_id, dev_id, MIN(start_datetime) AS first_login_datetime
FROM Ld
Group by
P_id, dev_id;

-- For each player and date, determine how many `kill_counts` were played by the player
-- so far. (a) Using window functions (b) Without window functions


-- Using window functions 

Select P_id, cast(start_datetime AS date) AS 'Date',
SUM(kill_count) over(partition by p_id order by start_datetime) AS total_kill_count
From Ld;

-- Without window functions

Select P_id, cast(start_datetime AS date) AS 'Date',
(select sum(kill_count) From Ld Ld2 where ld2.p_id = Ld.P_id
And ld2.start_datetime <= Ld.start_datetime) AS total_kill_count
From Ld;

--  Find the cumulative sum of stages crossed over `start_datetime`
-- for each `P_ID`, excluding the most recent `start_datetime`.

select P_id, start_datetime, SUM(stages_crossed)
Over(partition by P_id order by start_datetime ASC)
AS cumulative_sumofstages_crossed
FROM Ld;

-- Extract the top 3 highest sums of scores
-- for each `Dev_ID` and the corresponding `P_ID`

select sum(score) as highest_sum_score, p_id, dev_id
From ld
Group by p_id, dev_id
Order by sum(score) desc
Limit 3;

 -- Find players who scored more than 50% of the average score
 -- scored by the sum of scores for each `P_ID`.

Select p_id, sum(score) As total_scores
From Ld
Group by P_id
Having Sum(score) > 0.5*(select avg(score)
From ld);

-- Create a stored procedure to find the top `n` `headshots_count` based on each `Dev_ID`
-- and rank them in increasing order using `Row_Number`. Display the difficulty as well.

use gaming_analysis;

DELIMITER //

Create procedure top_n_headshots_count(in n int)
begin select Dev_ID,headshots_count, difficulty,
	  row_number() over (partition by Dev_ID order by headshots_count) AS Row_Numbers
FROM Ld
ORDER BY dev_ID,Row_Numbers
LIMIT n;
END//
Delimiter ;

CALL top_n_headshots_count(4);


