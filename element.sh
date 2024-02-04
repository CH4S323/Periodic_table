#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

Format_Text(){
  echo "$1" | while IFS='|' read id number symbol name mass melting boiling types
  do
    echo "The element with atomic number $number is $name ($symbol). It's a $types, with a mass of $mass amu. $name has a melting point of $melting celsius and a boiling point of $boiling celsius."
  done
}

No_Data(){
  echo "I could not find that element in the database."
}

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  #check number or not
  if [[ ! $1 =~ ^[0-9]+$ ]]
  #if not
  then
    # check length greater than 2
    if [[ $(expr length "$1") > 2 ]]
    # if greater
    then
      # get name
      Byname=$($PSQL "select * from elements inner join properties using(atomic_number) inner join types using(type_id) where name = initcap('$1')")
      if [[ -z $Byname ]]
      then
        No_Data
      else
        Format_Text $Byname
      fi
    # if not
    else
      # get symbol
      Bysymbol=$($PSQL "select * from elements inner join properties using(atomic_number) inner join types using(type_id) where symbol = initcap('$1')")
      if [[ -z $Bysymbol ]]
      then
        No_Data
      else
        Format_Text $Bysymbol
      fi
    fi
  #if number
  else
    # get atomic number
    Bynumber=$($PSQL "select * from elements inner join properties using(atomic_number) inner join types using(type_id) where atomic_number=$1")
    if [[ -z $Bynumber ]]
    then
      No_Data
    else
      Format_Text $Bynumber
    fi
  fi
fi
