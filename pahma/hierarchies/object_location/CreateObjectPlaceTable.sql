--
--
--
CREATE or REPLACE FUNCTION utils.createObjectPlaceTable() RETURNS VOID AS
$$
  DROP TABLE IF EXISTS utils.object_place_temp;

  SELECT DISTINCT *  INTO utils.object_place_temp
  FROM (
    SELECT
      cc.id,
      hcc.name collectionobjectcsid,
      ocg.objectcount objectcount,
      cc.objectnumber numberofobjects,
      pn.placecsid placecsid
    FROM collectionobjects_common cc
    JOIN misc m ON (cc.id = m.id AND m.lifecyclestate <> 'deleted')
    JOIN hierarchy hcc ON (cc.id = hcc.id)
    LEFT OUTER JOIN hierarchy hocg ON (cc.id = hocg.parentid AND hocg.primarytype = 'objectCountGroup' AND hocg.pos = 0)
    LEFT OUTER JOIN objectcountgroup ocg ON (hocg.id = ocg.id)
    LEFT OUTER JOIN collectionobjects_pahma_pahmafieldcollectionplacelist pl ON (cc.id = pl.id AND pl.pos = 0)
    LEFT OUTER JOIN places_common pc ON (pl.item = pc.refname)
    LEFT OUTER JOIN hierarchy hpc ON (pc.id = hpc.id AND hpc.primarytype = 'PlaceitemTenant15')
    LEFT OUTER JOIN utils.placename_hierarchy pn ON (hpc.name = pn.placecsid)
    ) AS object_place_subquery;

  CREATE INDEX opt_placecsid_ndx ON utils.object_place_temp(placecsid);
$$
LANGUAGE SQL
