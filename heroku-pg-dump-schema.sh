#!/bin/sh

# Usage: heroku-pg-dump-schema.sh HEROKU-APP-NAME SCHEMA-NAME

app=$1
schema=$3

db_url=`heroku config -s --app ${app} | grep DATABASE_URL`

export PGDATABASE=`sed -E 's|^.*/([a-zA-Z0-9]*)$|\1|' <<EOF
$db_url
EOF`
export PGHOST=`sed -E 's|^.*@([-.a-zA-Z0-9]*):.*$|\1|' <<EOF
$db_url
EOF`
export PGPORT=`sed -E 's|^.*:([-.a-zA-Z0-9]*)/.*$|\1|' <<EOF
$db_url
EOF`
export PGUSER=`sed -E 's|^.*//([a-zA-Z0-9]*):.*$|\1|' <<EOF
$db_url
EOF`
export PGPASSWORD=`sed -E 's|^.*:([a-zA-Z0-9]*)@.*$|\1|' <<EOF
$db_url
EOF`

pg_dump --schema ${schema} -Osx
