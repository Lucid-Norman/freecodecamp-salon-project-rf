#! /bin/bash




SERVICES=$(psql -X --username=freecodecamp --dbname=salon -t -c "SELECT service_id, name FROM services ORDER BY service_id;")


while true 
do

echo "$SERVICES" | while read SERVICE_ID BAR NAME
do
  echo "$SERVICE_ID) $NAME"
done




  echo "Please select a service:"
  read SERVICE_ID_SELECTED

  # check if exists
  SERVICE_NAME=$(psql -X --username=freecodecamp --dbname=salon -t -c "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")


  SERVICE_NAME=$(echo $SERVICE_NAME | xargs)

  # if not found, ask again
  if [[ -z $SERVICE_NAME ]]
  then
    echo "That service does not exist."
  else
    # valid → break out of loop
    break
  fi
done


echo "What's your phone number?"
read CUSTOMER_PHONE

# look up customer by phone
CUSTOMER_NAME=$(psql -X --username=freecodecamp --dbname=salon -t -c \
  "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")

# if customer not found, ask for name and insert them
if [[ -z $CUSTOMER_NAME ]]
then
  echo "I don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME

  psql -X --username=freecodecamp --dbname=salon -c \
    "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');"
fi

# now ask for the time
echo "What time would you like your service?"
read SERVICE_TIME






# get the customer_id for matching phone number
CUSTOMER_ID=$(psql -X --username=freecodecamp --dbname=salon -t -c \
  "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")

# insert the appointment into the table
psql -X --username=freecodecamp --dbname=salon -c \
  "INSERT INTO appointments(customer_id, service_id, time) \
   VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');"

# show confirmation for appointment being scheduled
echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."



