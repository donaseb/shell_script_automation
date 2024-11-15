#!/bin/bash

# Set variables
SERVER_URL="http://localhost:8080"  # URL of the ManageEngine server (replace with actual URL)
EMAIL="your-email@example.com"  # Replace with the recipient email address
SUBJECT="ManageEngine Server is in Critical State!"
SMTP_SERVER="smtp.example.com"  # Your SMTP server
SMTP_USER="your-smtp-user"  # Your SMTP username
SMTP_PASS="your-smtp-password"  # Your SMTP password

# Check server's HTTP status (adjust as needed for your critical state detection)
HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" $SERVER_URL)

# Define critical HTTP status codes (for example, 500 or 503)
CRITICAL_STATUS_CODES=("500" "503")

# Function to send email
send_email() {
  echo -e "Subject:$SUBJECT\n\nThe ManageEngine Server is in a critical state (HTTP Status: $HTTP_STATUS). Please check the server." | \
  sendmail -S $SMTP_SERVER -f $SMTP_USER -t $EMAIL
}

# Check if HTTP status code is critical
if [[ " ${CRITICAL_STATUS_CODES[@]} " =~ " $HTTP_STATUS " ]]; then
  echo "Critical issue detected with ManageEngine Server (HTTP Status: $HTTP_STATUS). Sending email..."
  send_email  # Call the function to send email notification
else
  echo "ManageEngine server is operating normally (HTTP Status: $HTTP_STATUS)."
fi
