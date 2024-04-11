#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ Ronnie's Salon ~~~~~\n"

MAIN () {
    
    #display services
    SERVICES_AVAILABLE=$($PSQL "select * from services")
    echo "$SERVICES_AVAILABLE" | while read SERVICE_ID BAR NAME
    do
    echo $SERVICE_ID') '$NAME
    done
    HIGHEST_SERVICE_ID_AVAILABLE=$($PSQL "select max(service_id) from services")
    #pick service
    read SERVICE_ID_SELECTED
    if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]] || [[ $SERVICE_ID_SELECTED -gt $HIGHEST_SERVICE_ID_AVAILABLE ]]
    then
    #if service doesnt exist
    #return to main "pick one we have"
    echo -e "\nPlease enter a valid service."
    MAIN 
    else
    
    SERVICES
    fi
}

SERVICES () {
  #add service id 
  #enter service id
  #enter phone number
  #if phone doesnt exist
  #enter name
  echo -e "\nEnter your phone Number Please!"
  read CUSTOMER_PHONE
  CUSTOMER_EXIST_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_EXIST_ID ]]
  then
  echo -e "\nWhat's your name?"
  read CUSTOMER_NAME
  INSERT_NEW_CUSTOMER=$($PSQL "insert into customers(name, phone) values('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  echo -e "\nWhen do you wish for your appointment?"
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
  read SERVICE_TIME
  INSERT_APPOINTMENT=$($PSQL "insert into appointments(time, customer_id, service_id) values('$SERVICE_TIME', '$CUSTOMER_ID', '$SERVICE_ID_SELECTED')")
  CUSTOMER_NAME=$($PSQL "select name from customers where customer_id = $CUSTOMER_ID")
  SERVICE_NAME=$($PSQL "select name from services where service_id = '$SERVICE_ID_SELECTED'")
  echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
  EXIT
}



EXIT() {
  echo -e "\nThank you for visiting\n"
  
}
MAIN