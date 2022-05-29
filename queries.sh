#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT (SUM(winner_goals) + SUM(opponent_goals)) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals),2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT (SUM(winner_goals) + SUM(opponent_goals))::numeric/count(game_id)  FROM games")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(winner_goals) FROM games")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT count(game_id) FROM games where winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name from teams as t left join games as g on t.team_id = g.winner_id where round = 'Final' and year=2018")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
winner="$($PSQL "SELECT name from teams t left join games g on t.team_id = g.winner_id where round = 'Eighth-Final' and year=2014")"
opponent="$($PSQL "SELECT name from teams t left join games g on t.team_id = g.opponent_id where round = 'Eighth-Final' and year=2014")"
echo -e "$winner""\n$opponent" | sort | uniq
echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT distinct(name) from games g left join teams as t on g.winner_id = t.team_id order by name")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "select year, name from games g left join teams as t on g.winner_id = t.team_id where round = 'Final' order by year")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name from teams t left join games g on t.team_id = g.winner_id where name LIKE '%Co%'")"
