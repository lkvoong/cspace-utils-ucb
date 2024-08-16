--
--
--

CREATE or REPLACE FUNCTION utils.createObjectPlaceView() RETURNS VOID AS
$$
  CREATE OR REPLACE VIEW utils.object_place_view AS
  SELECT
    cc.id,
    hcc.name collectionobjectcsid,
    ocg.objectcount numberofobjects,
    cc.objectnumber objectnumber,
    pn.placecsid placecsid
  FROM collectionobjects_common cc
  JOIN misc m ON (cc.id = m.id AND m.lifecyclestate <> 'deleted')
  JOIN hierarchy hcc ON (cc.id = hcc.id)
  LEFT OUTER JOIN hierarchy hocg ON (hcc.id = hocg.parentid AND hocg.primarytype = 'objectCountGroup' AND hocg.pos = 0)
  LEFT OUTER JOIN objectcountgroup ocg ON (hocg.id = ocg.id)
  JOIN collectionobjects_pahma_pahmafieldcollectionplacelist pl ON (cc.id = pl.id AND pl.pos = 0)
  JOIN places_common pc ON (pl.item = pc.refname)
  JOIN hierarchy hpc ON (pc.id = hpc.id AND hpc.primarytype = 'PlaceitemTenant15')
  JOIN utils.placename_hierarchy pn ON (hpc.name = pn.placecsid)
$$
LANGUAGE SQL
