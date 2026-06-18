#!/bin/bash

# Configuration - Change these values if you want a different custom user/password
DB_USER="mycustomuser"
DB_PASS="mycustompassword"

# Navigate to the script's directory so it runs in the correct path
cd "$(dirname "$0")"

# Start the docker compose services
echo "Starting Oracle database container..."
docker compose up -d

# Wait for Oracle container to be fully ready
echo "Waiting for Oracle database to be ready (this may take a minute)..."
until docker logs oracle-xe11 2>&1 | grep -q "DATABASE IS READY TO USE!"; do
    sleep 3
done
echo "Oracle database is ready!"

# Create custom user
echo "Creating custom Oracle user '$DB_USER'..."
docker exec -it oracle-xe11 createAppUser "$DB_USER" "$DB_PASS"

# Install oracle-instantclient-sqlplus
echo "Installing oracle-instantclient-sqlplus via yay..."
yay -S --needed oracle-instantclient-sqlplus

echo "Setup completed successfully!"
echo "You can now connect to your Oracle database using:"
echo "  sqlplus $DB_USER/$DB_PASS@//localhost:1521/XE"

