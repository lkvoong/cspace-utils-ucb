--
-- Function utils.createObjectPlaceTable() to create table object_place_temp and index on place csid.
-- Used to map collection object to collection place.
-- References table utils.placename_hierarchy.
-- Referenced by table utils.object_place_location.
--

CREATE OR REPLACE FUNCTION utils.createObjectPlaceTable() RETURNS VOID AS
$$
  DROP TABLE IF EXISTS utils.object_place_temp;

  SELECT * INTO utils.object_place_temp
  FROM (
    SELECT DISTINCT ON (cc.id, pn.placecsid)
      cc.id,
      hcc.name collectionobjectcsid,
      ocg.objectcount numberofobjects,
      cc.objectnumber objectnumber,
      pn.placecsid placecsid
    FROM collectionobjects_common cc
    JOIN misc m ON (cc.id = m.id AND m.lifecyclestate <> 'deleted')
    JOIN hierarchy hcc ON (cc.id = hcc.id)
    LEFT OUTER JOIN hierarchy hocg ON (cc.id = hocg.parentid AND hocg.primarytype = 'objectCountGroup')
    LEFT OUTER JOIN objectcountgroup ocg ON (hocg.id = ocg.id AND getdispl(ocg.objectcounttype) = 'piece count')
    LEFT OUTER JOIN collectionobjects_pahma_pahmafieldcollectionplacelist pl ON (cc.id = pl.id AND pl.pos = 0)
    LEFT OUTER JOIN places_common pc ON (pl.item = pc.refname)
    LEFT OUTER JOIN hierarchy hpc ON (pc.id = hpc.id AND hpc.primarytype = 'PlaceitemTenant15')
    LEFT OUTER JOIN utils.placename_hierarchy pn ON (hpc.name = pn.placecsid)
    ORDER BY cc.id, pn.placecsid, ocg.objectcountdate DESC NULLS LAST
  ) object_place_subquery;

  CREATE INDEX opt_placecsid_ndx ON utils.object_place_temp (placecsid);
$$
LANGUAGE SQL
