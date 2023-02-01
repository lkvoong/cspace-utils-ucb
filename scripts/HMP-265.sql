-- HMP-265: Run the sql to create new functions for PAHMA Object Class Hierarchy.
-- Run order:
--   1) utils.createObjectClassHierarchyTable()
--      select utils.createObjectClassHierarchyTable();
--   2) utils.populateObjectClassHierarchyTable()
--      select utils.populateObjectClassHierarchyTable();
--   3) utils.updateObjectClassHierarchyTable()
--      select utils.updateObjectClassHierarchyTable();
--   4) utils.refreshObjectclassHierarchyTable()
--      select utils.refreshObjectclassHierarchyTable();
--

-- utils.createObjectClassHierarchyTable()
--
-- A function to create an empty objectclass_hierarchy table in the utils schema, if one does not already exist.
-- It does not drop or recreate any existing table.

CREATE OR REPLACE FUNCTION utils.createObjectclassHierarchyTable() RETURNS void AS
$$
DECLARE
BEGIN
  DROP TABLE IF EXISTS utils.objectclass_hierarchy CASCADE;
  
  CREATE TABLE utils.objectclass_hierarchy (
    objectclasscsid text,
    objectclass text,
    parentid text,
    nextcsid text,
    objectclass_hierarchy text,
    csid_hierarchy text );

  CREATE INDEX uoch_occsid_ndx on utils.objectclass_hierarchy (objectclasscsid);
  CREATE INDEX uoch_ocname_ndx on utils.objectclass_hierarchy (objectclass);
END;
$$
LANGUAGE plpgsql;

-- Run utils.createObjectClassHierarchyTable() to create utils.objectclass_hierarchy table.
--
select utils.createObjectClassHierarchyTable();

-- utils.populateObjectClassHierarchyTable()
--
-- A function to insert the initial rows into the objectclass_hierarchy table, which must already exist.
-- The hierarchy columns will be built up later by another procedure, utils.updateObjectClassHierarchyTable().

CREATE OR REPLACE FUNCTION utils.populateObjectclassHierarchyTable() RETURNS void AS
$$
  IF EXISTS ( SELECT relname
              FROM pg_catalog.pg_class c
              JOIN pg_catalog.pg_namespace n ON (n.oid = c.relnamespace)
              WHERE c.relname = 'objectclass_hierarchy'
              AND n.nspname = 'utils' )
  THEN

    TRUNCATE TABLE utils.objectclass_hierarchy;

    WITH objectclass_hierarchyquery AS (
      SELECT
        h.name objectclasscsid,
        getdispl(cnc.refname) objectclass,
        rc.objectcsid broaderobjectclasscsid,
        getdispl(cco.refname) broaderobjectclass
      FROM public.concepts_common ccs
        JOIN misc m ON (ccs.id = m.id AND m.lifecyclestate != 'deleted')
        LEFT OUTER JOIN hierarchy hccs ON (ccs.id = hccs.id AND hccs.primarytype = 'Conceptitem')
        LEFT OUTER JOIN relations_common rc ON (hccs.name = rc.subjectcsid)
        LEFT OUTER JOIN hierarchy hcco ON (rc.objectcsid = hcco.name AND hcco.primarytype = 'Conceptitem')
        LEFT OUTER JOIN concepts_common cco ON (cco.id = hcco.id)
        LEFT OUTER JOIN hierarchy hccsa ON (ccs.inauthority = hccsa.name)
        LEFT OUTER JOIN conceptauthorities_common cacs ON (hccsa.id = cacs.id)
      WHERE cacs.shortidentifier = 'objectclass'
    )
    INSERT INTO utils.objectclass_hierarchy
    SELECT DISTINCT
      objectclasscsid,
      objectclass,
      broaderobjectclasscsid AS parentcsid,
      broaderobjectclasscsid AS nextcsid,
      objectclass AS objectclass_hierarchy,
      objectclasscsid AS csid_hierarchy
    FROM objectclass_hierarchyquery;
  END IF;
END;
$$
LANGUAGE plpgsql;

-- Run utils.populateObjectClassHierarchyTable() to populate utils.objectclass_hierarchy table with itial data.
--
select utils.populateObjectClassHierarchyTable();

-- utils.updateObjectClassHierarchyTable()
--
-- A function to insert the aggregated objectclass_hierarchy into the objectclass_hierarchy table,
-- which must already exist.

CREATE OR REPLACE FUNCTION utils.updateObjectclassHierarchyTable() RETURNS bigint AS
$$
DECLARE
  ph text;
  ch text;
  nxt utils.objectclass_hierarchy.nextcsid%TYPE;
  cnt int;
BEGIN
  ph := '';
  ch := '';
  nxt := 1;
  cnt := 1;

  WHILE cnt < 100 LOOP
    UPDATE utils.objectclass_hierarchy p1
    SET nextcsid = NULL,
        csid_hierarchy = p2.csid_hierarchy || '|' || p1.objectclasscsid,
        objectclass_hierarchy = p2.objectclass_hierarchy || '|' || p1.objectclass
    FROM utils.objectclass_hierarchy p2
    WHERE p1.nextcsid IS NOT NULL
    AND p1.nextcsid = p2.objectclasscsid
    AND p2.nextcsid IS NULL;

    IF FOUND THEN
      SELECT INTO cnt cnt+1;
    ELSE
      EXIT;
    END IF;
  END LOOP;

  RETURN cnt;
END;
$$
LANGUAGE plpgsql;

-- Run utils.updateObjectClassHierarchyTable() to update utils.objectclass_hiearchy fields with hierarchy data.
--
select utils.updateObjectClassHierarchyTable();

-- utils.refreshObjectclassHierarchyTable()
--
--  A function to keep the objectclass_hierarchy table up to date.
--  It is called from a nightly cron job and logs to utils.refresh_log table.

CREATE OR REPLACE FUNCTION utils.refreshObjectclassHierarchyTable() RETURNS void AS
$$
BEGIN
   insert into utils.refresh_log (msg) values ( 'Creating objectclass_hierarchy table' );
   select utils.createObjectclassHierarchyTable();

   insert into utils.refresh_log (msg) values ( 'Populating objectclass_hierarchy table' );
   select utils.populateObjectclassHierarchyTable();

   insert into utils.refresh_log (msg) values ( 'Updating objectclass_hierarchy table' );
   select utils.updateObjectclassHierarchyTable();

   insert into utils.refresh_log (msg) values ( 'All done' );
END;
$$
LANGUAGE plpgsql;

-- Run utils.refreshObjectclassHierarchyTable(); to refresh utils.objectclass_hiearchy table.
-- Also, to check the refresh function runs properly.
--
select utils.refreshObjectclassHierarchyTable();

