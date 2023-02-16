#!/usr/bin/bash

export PGHOST="localhost"
export PGPORT="54321"

export EMAIL_FROM="cspace-support@lists.berkeley.edu"
export CONTACT="$1"

DATE=`date +"%Y%m%d-%H%M%S"`
OUTPUT_DIR="/cspace/cspace-users/${DATE}"
mkdir -p ${OUTPUT_DIR}

# bampfa
/usr/bin/psql -U bampfa -d cspace_bampfa -c "\\COPY (SELECT ac.userid,ac.screen_name,ac.status,r.displayname,RIGHT(u.passwd,20) AS passwd,CASE WHEN COALESCE(u.salt,'NO') = 'NO' then 'NO' ELSE 'YES' END AS \"salt?\",u.created_at, ac.updated_at, u.updated_at as credentials_changed,u.lastlogin FROM accounts_common ac LEFT JOIN users u ON ac.userid=u.username LEFT JOIN accounts_roles ar ON ac.userid=ar.user_id LEFT JOIN accounts_tenants at ON ac.csid=at.tenants_accounts_common_csid LEFT JOIN roles r ON ar.role_id=r.csid WHERE at.tenant_id='55' AND (ar.role_name != 'ROLE_SPRING_ADMIN' OR ar.role_name IS NULL) ORDER BY ac.userid) TO '${OUTPUT_DIR}/bampfausers.csv' WITH DELIMITER ',' CSV HEADER"

# botgarden
/usr/bin/psql -U ucbg -d cspace_botgarden -c "\\COPY (SELECT ac.userid,ac.screen_name,ac.status,r.displayname,RIGHT(u.passwd,20) AS passwd,CASE WHEN COALESCE(u.salt,'NO') = 'NO' then 'NO' ELSE 'YES' END AS \"salt?\",u.created_at, ac.updated_at, u.updated_at as credentials_changed,u.lastlogin FROM accounts_common ac LEFT JOIN users u ON ac.userid=u.username LEFT JOIN accounts_roles ar ON ac.userid=ar.user_id LEFT JOIN accounts_tenants at ON ac.csid=at.tenants_accounts_common_csid LEFT JOIN roles r ON ar.role_id=r.csid WHERE at.tenant_id='35' AND (ar.role_name != 'ROLE_SPRING_ADMIN' OR ar.role_name IS NULL) ORDER BY ac.userid) TO '${OUTPUT_DIR}/botgardenusers.csv' WITH DELIMITER ',' CSV HEADER"

# cinefiles
/usr/bin/psql -U cinefiles -d cspace_cinefiles -c "\\COPY (SELECT ac.userid,ac.screen_name,ac.status,r.displayname,RIGHT(u.passwd,20) AS passwd,CASE WHEN COALESCE(u.salt,'NO') = 'NO' then 'NO' ELSE 'YES' END AS \"salt?\",u.created_at, ac.updated_at, u.updated_at as credentials_changed,u.lastlogin FROM accounts_common ac LEFT JOIN users u ON ac.userid=u.username LEFT JOIN accounts_roles ar ON ac.userid=ar.user_id LEFT JOIN accounts_tenants at ON ac.csid=at.tenants_accounts_common_csid LEFT JOIN roles r ON ar.role_id=r.csid WHERE at.tenant_id='50' AND (ar.role_name != 'ROLE_SPRING_ADMIN' OR ar.role_name IS NULL) ORDER BY ac.userid) TO '${OUTPUT_DIR}/cinefilesusers.csv' WITH DELIMITER ',' CSV HEADER"

# pahma
/usr/bin/psql -U pahma -d cspace_pahma -c "\\COPY (SELECT ac.userid,ac.screen_name,ac.status,r.displayname,RIGHT(u.passwd,20) AS passwd,CASE WHEN COALESCE(u.salt,'NO') = 'NO' then 'NO' ELSE 'YES' END AS \"salt?\",u.created_at, ac.updated_at, u.updated_at as credentials_changed,u.lastlogin FROM accounts_common ac LEFT JOIN users u ON ac.userid=u.username LEFT JOIN accounts_roles ar ON ac.userid=ar.user_id LEFT JOIN accounts_tenants at ON ac.csid=at.tenants_accounts_common_csid LEFT JOIN roles r ON ar.role_id=r.csid WHERE at.tenant_id='15' AND (ar.role_name != 'ROLE_SPRING_ADMIN' OR ar.role_name IS NULL) ORDER BY ac.userid) TO '${OUTPUT_DIR}/pahmausers.csv' WITH DELIMITER ',' CSV HEADER"

# ucjeps
/usr/bin/psql -U ucjeps -d cspace_ucjeps -c "\\COPY (SELECT ac.userid,ac.screen_name,ac.status,r.displayname,RIGHT(u.passwd,20) AS passwd,CASE WHEN COALESCE(u.salt,'NO') = 'NO' then 'NO' ELSE 'YES' END AS \"salt?\",u.created_at, ac.updated_at, u.updated_at as credentials_changed,u.lastlogin FROM accounts_common ac LEFT JOIN users u ON ac.userid=u.username LEFT JOIN accounts_roles ar ON ac.userid=ar.user_id LEFT JOIN accounts_tenants at ON ac.csid=at.tenants_accounts_common_csid LEFT JOIN roles r ON ar.role_id=r.csid WHERE at.tenant_id='20' AND (ar.role_name != 'ROLE_SPRING_ADMIN' OR ar.role_name IS NULL) ORDER BY ac.userid) TO '${OUTPUT_DIR}/ucjepsusers.csv' WITH DELIMITER ',' CSV HEADER"

# this artifice is required: .tgz needs to be built outside this dir, but then moved into it
cd ${OUTPUT_DIR}
tar czf ~/users-${DATE}.tgz .
mv ~/users-${DATE}.tgz .

echo "Your regular list of CSpace users is on the blacklight server at:

   ${OUTPUT_DIR}.

Please ask Ops to fetch it for you if you don't have access.

Enjoy.

The DevOps Team" | mail -r ${EMAIL_FROM} -s "lists of users is available, ${DATE}" ${CONTACT} -- ${CONTACT}
