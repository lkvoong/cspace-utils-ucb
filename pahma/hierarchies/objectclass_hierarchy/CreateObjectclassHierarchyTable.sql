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

