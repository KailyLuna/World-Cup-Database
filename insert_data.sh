#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# TRUNCATE to delete all data from a table.
echo $($PSQL "TRUNCATE TABLE games, teams")

# Cat is a terminal command for printing the contents of a file.
# Piping it into a while loop to read the row by row.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Inserting teams table data (first - winner team name)
      # excluding the column 'names' row
      # retrieving winner team name:
      if [[ $WINNER != "winner" ]]
        then
          # get team name
          TEAM1_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
            #if team name not found
            if [[ -z $TEAM1_NAME ]]
              then
              #insert new team
              INSERT_TEAM1_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
                #echo call to confirm that the team was inserted
                if [[ $INSERT_TEAM1_NAME == "INSERT 0 1" ]]
                  then
                    echo Inserted team $WINNER
                fi
            fi
      fi

    # Inserting (second - opponent team name)
      # exclude the column 'names' row
      # retrieving the opponent team name
      if [[ $OPPONENT != "opponent" ]]
        then
          # get team name
          TEAM2_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
            #if team name not found
            if [[ -z $TEAM2_NAME ]]
              then
              #insert new team
              INSERT_TEAM2_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
                #echo call to confirm the team was inserted
                if [[ $INSERT_TEAM2_NAME == "INSERT 0 1" ]]
                  then
                    echo Inserted team $OPPONENT
                fi
            fi
      fi

  # INSERT GAMES TABLE DATA
    # excluding the column 'names' row
    if [[ YEAR != "year" ]]
      then
        # get winner_id
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        # get opponent_id
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        # insert new game row
        INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
          # echo call to confirm what was added
          if [[ $INSERT_GAME == "INSERT 0 1" ]]
            then
              echo New game added: $YEAR, $ROUND, $WINNER_ID VS $OPPONENT_ID, score $WINNER_GOALS : $OPPONENT_GOALS
          fi
    fi
    
done
