#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
  { cat games.csv | cut -f3 -d, | sort | uniq; cat games.csv | cut -f4 -d, | sort | uniq; } | sort | uniq | while read TEAM
   do 
   if [[ $TEAM != 'winner' && $TEAM != 'opponent' ]]
   then
    INSERTTEAM=$($PSQL "Insert into teams(name) values('$TEAM')")
   fi
   done 
  TEAMID=$($PSQL "select concat(name,'=', team_id, ',') from teams")
  arr=(`echo $TEAMID | sed  s/\ //g | tr ',' ' '`)
  cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
  do
  if [[ $YEAR != 'year' ]]
  then
  FORMATTEDWINNER=(`echo $WINNER | sed  s/\ //g`)
  FORMATTEDOPPONENT=(`echo $OPPONENT | sed  s/\ //g`)
  for i in "${arr[@]}"
  do 
    if [[ $i =~ "$FORMATTEDWINNER" ]]; then
     winnerId=$(echo "$i" | cut -d= -f2)
    fi
    if [[ $i =~  "$FORMATTEDOPPONENT" ]]; then
     opponentId=$(echo "$i" | cut -d= -f2)
    fi
  done
  INSERTGAMES=$($PSQL "Insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $winnerId, $opponentId, $WINNERGOALS, $OPPONENTGOALS)")
  fi
  done