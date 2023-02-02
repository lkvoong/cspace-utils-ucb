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

