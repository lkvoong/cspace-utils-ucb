--
-- Function utils.createCurrentLocationTable() to create table utils.current_location_temp and index.
-- Used to map collection object to current storage location and crate.
-- Referenced by table utils.object_place_location.
--

CREATE OR REPLACE FUNCTION utils.createCurrentLocationTable() RETURNS VOID AS
$$
  DROP TABLE IF EXISTS utils.current_location_temp;

  SELECT * INTO utils.current_location_temp
  FROM (
    SELECT
      cc.id
      hcc.name AS collectionobjectcsid,
      GETDISPL(cc.computedcurrentlocation) AS storagelocation,
      GETDISPL(ca.computedcrate) AS crate
    FROM collectionobjects_common cc
    JOIN misc m ON (cc.id = m.id AND m.lifecyclestate <> 'deleted')
    JOIN hierarchy hcc ON (cc.id = hcc.id)
    LEFT OUTER JOIN collectionobjects_anthropology ca ON (ca.id = cc.id)
  ) current_location_subquery;

  CREATE INDEX clt_objcsid_ndx ON utils.current_location_temp (collectionobjectcsid);
$$
LANGUAGE SQL
