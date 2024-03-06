#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

SERVICE_LIST() {
  SERVICE_LIST=$($PSQL "SELECT service_id,name from services order by service_id asc")
  echo "$SERVICE_LIST" | while read SERVICE_ID BAR NAME; do
    echo "$SERVICE_ID) $NAME"
  done
}
echo -e "Welcome to My Salon, how can I help you?\n"

SERVICE_LIST

read SERVICE_ID_SELECTED
SERVICE_NAME=$($PSQL "SELECT NAME FROM services where service_id = '$SERVICE_ID_SELECTED'")

# if input is not a number
if [[ ! $SERVICE_ID_SELECTED =~ ^[1-5]+$ ]]
then
  # send to main menu
  SERVICE_LIST "I could not find that service. What would you like today?"
else
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT NAME FROM customers where phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMR=$($PSQL "insert into customers(name,phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  fi 
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers where phone = '$CUSTOMER_PHONE'")
  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  INSERT_CUSTOMR=$($PSQL "insert into appointments(customer_id,service_id,time) values('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

fi
