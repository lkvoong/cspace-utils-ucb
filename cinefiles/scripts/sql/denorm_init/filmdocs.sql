-- filmdocs table used by CineFiles denorm
-- CRH 2/23/2014
-- LKV 9/18/2025 remove unused join to hierarchy

CREATE TABLE cinefiles_denorm.filmdocs AS
  SELECT
    wc.shortidentifier film_id,
    cast(co.objectnumber as bigint) doc_id,
    'not used' as entered,
    'not used' as modified,
    'not used' as entered_by,
    'not used' as verified_by,
    'not used' as note
  FROM collectionobjects_common co
  JOIN misc m ON (
    co.id = m.id AND m.lifecyclestate <> 'deleted')
  JOIN collectionobjects_cinefiles_filmsubjects ccf ON co.id = ccf.id
  JOIN works_common wc on wc.refname = ccf.item
  WHERE (co.objectnumber ~ '^[0-9]+$' )
  AND ccf.item IS NOT NULL
  AND ccf.item <> ''
  ORDER BY wc.shortidentifier, cast(co.objectnumber as bigint);

GRANT SELECT ON cinefiles_denorm.filmdocs TO GROUP reporters;
GRANT SELECT ON cinefiles_denorm.filmdocs TO GROUP cinereaders;
