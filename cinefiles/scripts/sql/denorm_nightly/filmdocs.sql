-- filmdocs table used by CineFiles denorm
--
-- CRH 2/23/2014
--
-- this script creates a temporary table, which will be renamed
-- after all of the denorm tables have been successfully created.
--
-- Modified GLJ 8/3/2014
-- LKV 09/18/2025 remove unused join to hierarchy

DROP TABLE IF EXISTS cinefiles_denorm.filmdocstmp;

CREATE TABLE cinefiles_denorm.filmdocstmp AS
  SELECT
    wc.shortidentifier film_id,
    cast(co.objectnumber AS bigint) doc_id,
    'not used'::char(8) AS entered,
    'not used'::char(8) AS modified,
    'not used'::char(8) AS entered_by,
    'not used'::char(8) AS verified_by,
    'not used'::char(8) AS note
  FROM collectionobjects_common co
  JOIN misc m ON (
    co.id = m.id
    AND m.lifecyclestate <> 'deleted')
  JOIN collectionobjects_cinefiles_filmsubjects ccf ON co.id = ccf.id
  JOIN works_common wc ON wc.refname = ccf.item
  WHERE co.objectnumber ~ '^[0-9]+$'
  AND ccf.item IS NOT NULL
  AND ccf.item <> ''
  ORDER BY wc.shortidentifier, cast(co.objectnumber AS bigint);

GRANT SELECT ON cinefiles_denorm.filmdocstmp TO GROUP reporters_cinefiles;
GRANT SELECT ON cinefiles_denorm.filmdocstmp TO reader_cinefiles;

SELECT COUNT(1) FROM cinefiles_denorm.filmdocs;
SELECT COUNT(1) FROM cinefiles_denorm.filmdocstmp;

