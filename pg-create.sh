#!/usr/bin/env bash
set -e

# SQL is from db directory.
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE TYPE notification AS ENUM ('all', 'schedule', 'launch');
    CREATE TABLE subscribed_channels (
        channel_id TEXT PRIMARY KEY NOT NULL,
        guild_id TEXT NOT NULL,
        channel_name TEXT NOT NULL,
        notification_type notification NOT NULL,
        launch_mentions TEXT
    );
    CREATE TABLE metrics (
        id serial PRIMARY KEY NOT NULL,
        "action" TEXT NOT NULL,
        guild_id TEXT NOT NULL,
        "time" TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
    );
    CREATE TABLE counts (
        id serial PRIMARY KEY NOT NULL,
        guild_count INT NOT NULL,
        subscribed_count INT NOT NULL,
        "time" TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
    );
    CREATE TABLE sessions (
        session_id TEXT PRIMARY KEY NOT NULL,
        session_creation_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
        access_token_encrypted BYTEA NOT NULL,
        access_token_expires_at TIMESTAMP NOT NULL,
        refresh_token_encrypted BYTEA NOT NULL,
        refresh_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
    );
EOSQL
