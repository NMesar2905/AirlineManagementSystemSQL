FROM mcr.microsoft.com/mssql/server:2019-latest
USER root

# Install mssql-tools
RUN apt-get update && apt-get install -y curl apt-transport-https gnupg && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools unixodbc-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PATH="$PATH:/opt/mssql-tools/bin"

# Copy Scripts
COPY initdatabases.sh /docker-entrypoint-initdb.d/initdatabases.sh
COPY sqlserver-init/ /sqlserver-init/

RUN chmod +x /docker-entrypoint-initdb.d/initdatabases.sh

USER mssql

# Start SQL Server in background and run initialization script
CMD ["/bin/bash", "/docker-entrypoint-initdb.d/initdatabases.sh"]