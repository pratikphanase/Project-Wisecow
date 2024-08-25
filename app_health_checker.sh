Application URL
APP_URL="http://54.198.19.176:4499/"

# Check the application status
HTTP_CODE=$(curl -o /dev/null -s -w "%{http_code}" "$APP_URL")

# Report status based on HTTP code
if [ "$HTTP_CODE" -eq 200 ]; then
    echo "Application is UP. HTTP status code: $HTTP_CODE"
else
    echo "Application is DOWN. HTTP status code: $HTTP_CODE"
fi
