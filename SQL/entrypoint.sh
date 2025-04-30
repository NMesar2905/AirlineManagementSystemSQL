#!/bin/bash

# Start SQL Server in the background
/opt/mssql/bin/sqlservr &

# Start the script to configure the DB
./configure-db.sh

# Wait for SQL Server to exit
wait