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
OR:



#!/bin/bash

# Configuration
RMM_API_URL="https://rmm.example.com/api/v1/servers/health"  # Change with your RMM API endpoint
API_KEY="your_api_key"  # Your API Key or authentication token
SERVER_ID="server123"  # The ID of the server you're monitoring
CRITICAL_STATUS="Critical"  # Define the critical status keyword
EMAIL_SUBJECT="Alert: Server Health Critical"
EMAIL_TO="your_email@example.com"  # Email recipient
EMAIL_FROM="rmm_alerts@example.com"  # From email
SMTP_SERVER="smtp.example.com"  # SMTP server to send emails
SMTP_PORT="587"  # SMTP server port
SMTP_USER="smtp_user"  # SMTP user
SMTP_PASS="smtp_password"  # SMTP password

# Function to check health status from RMM API
check_server_health() {
    # Make API call to RMM and fetch the health status of the server
    health_status=$(curl -s -H "Authorization: Bearer $API_KEY" "$RMM_API_URL/$SERVER_ID" | jq -r '.status')  # Assumes response is JSON and uses jq to extract status
    echo "Server Health Status: $health_status"
}

# Function to send email notification
send_email() {
    local subject="$1"
    local message="$2"

    # Sending the email using sendmail or mail command
    echo -e "Subject: $subject\nFrom: $EMAIL_FROM\nTo: $EMAIL_TO\n\n$message" | sendmail -S "$SMTP_SERVER:$SMTP_PORT" -au"$SMTP_USER" -ap"$SMTP_PASS" "$EMAIL_TO"
}

# Main logic
check_server_health

if [ "$health_status" == "$CRITICAL_STATUS" ]; then
    # Prepare the email body
    email_body="Alert: The health status of server $SERVER_ID is CRITICAL. Immediate attention is required."
    
    # Send the email notification
    send_email "$EMAIL_SUBJECT" "$email_body"
else
    echo "Server health status is not critical. No action needed."
fi
