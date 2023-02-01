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

