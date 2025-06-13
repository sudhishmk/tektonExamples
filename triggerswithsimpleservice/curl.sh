curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
        "serviceName": "my-service",
        "status": "running"
      }' \
  http://$EVENT_LISTENER_URL
