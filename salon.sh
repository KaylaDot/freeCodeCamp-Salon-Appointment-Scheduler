#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
  if [[ -n $1 ]]
  then
    echo $1
  fi
  echo -e "\n~~ Salon ~~\n"
  echo "How can we help you today?"
  echo -e "\n1) cut\n2) color\n3) style\n4) perm\n5) trim\n"
  read SERVICE_ID_SELECTED
  SERVICE_NAME="$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")"
  if [[ -z $SERVICE_NAME ]]
  then
    MAIN_MENU "Please pick a valid service."
  else
    APPOINTMENT $SERVICE_NAME $SERVICE_ID_SELECTED
  fi
}

APPOINTMENT() {
  echo "What's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo "What's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER="$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")"
  fi
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  CUSTOMER_NAME=$(echo $CUSTOMER_NAME | sed 's/ //g')
  echo "When would you like your $1, $CUSTOMER_NAME?"
  read SERVICE_TIME
  INSERT_APPOINTMENT="$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $2, '$SERVICE_TIME')")"
  echo "I have put you down for a $1 at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
