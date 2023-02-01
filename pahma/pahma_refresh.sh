#!/bin/bash

export BASEDIR=${HOME}/cspace-solr-ucb/pahma
export PGUSER=nuxeo_pahma
export PGPASSWORD="${PAHMA_PGPASSWORD}" # apply via SSM param store
export PGDATABASE=pahma_domain_pahma
export PGHOST="${PAHMA_PGHOST}"
export PGPORT="${PAHMA_PGPORT}"
export EMAIL_FROM=${PAHMA_EMAIL_FROM}
export CONTACT="${PAHMA_CONTACT}"

time psql -q -t -c "select utils.refreshculturehierarchytable();"
time psql -q -t -c "select utils.refreshmaterialhierarchytable();"
time psql -q -t -c "select utils.refreshtaxonhierarchytable();"
time psql -q -t -c "select utils.refreshobjectplacelocationtable();"

cd ${BASEDIR} ; psql -q -t -f checkstatus.sql | mail -r ${EMAIL_FROM} -s "hierarchies refresh" "${CONTACT}"
