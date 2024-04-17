#!/bin/bash

echo -e "local replication $POSTGRES_USER trust\nhost replication $POSTGRES_USER 127.0.0.1/32 trust\nhost replication $POSTGRES_USER ::1/128 trust" >> "$PGDATA/pg_hba.conf"
echo -e "# REPLICATION\nwal_level = logical\nmax_wal_senders = 1\nmax_replication_slots = 1" >> "$PGDATA/postgresql.conf"
