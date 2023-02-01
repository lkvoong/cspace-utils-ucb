#!/bin/bash
# UCB's version of pahma_refresh.sh, originally with the same name and renamed to pahma_refresh_ucb.sh.

export BASEDIR=${HOME}/cspace-utils-ucb/pahma
export PGUSER=nuxeo_pahma
export PGPASSWORD="${PAHMA_PGPASSWORD}" # apply via SSM param store
export PGDATABASE=pahma_domain_pahma
export PGHOST="${PAHMA_PGHOST}"
export PGPORT="${PAHMA_PGPORT}"

time psql -q -t -c "select utils.refreshculturehierarchytable();"
time psql -q -t -c "select utils.refreshmaterialhierarchytable();"
time psql -q -t -c "select utils.refreshtaxonhierarchytable();"
time psql -q -t -c "select utils.refreshobjectplacelocationtable();"
time psql -q -t -c "select utils.refreshobjectclasshierarchytable();"

