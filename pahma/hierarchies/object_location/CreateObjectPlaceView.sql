--
-- DEPRECATED: utils.createObjectPlaceTable() function creates table object_place_temp using direct query
-- instead of populating from view object_place_view.
--
-- Function utils.createObjectPlaceView() to create view object_place_view.
-- Used to map collection object to collection place.
-- References utils.placename_hierarchy.
--

CREATE OR REPLACE FUNCTION utils.createObjectPlaceView() RETURNS VOID AS
$$
  CREATE OR REPLACE VIEW utils.object_place_view AS
    SELECT DISTINCT ON (cc.id, pn.placecsid)
      cc.id,
      hcc.name collectionobjectcsid,
      ocg.objectcount numberofobjects,
      cc.objectnumber objectnumber,
      pn.placecsid placecsid
    FROM collectionobjects_common cc
    JOIN misc m ON (cc.id = m.id AND m.lifecyclestate <> 'deleted')
    JOIN hierarchy hcc ON (cc.id = hcc.id)
    LEFT OUTER JOIN hierarchy hocg ON (hcc.id = hocg.parentid AND hocg.primarytype = 'objectCountGroup')
    LEFT OUTER JOIN objectcountgroup ocg ON (hocg.id = ocg.id AND getdispl(ocg.objectcounttype) = 'piece count')
    LEFT OUTER JOIN collectionobjects_pahma_pahmafieldcollectionplacelist pl ON (cc.id = pl.id AND pl.pos = 0)
    LEFT OUTER JOIN places_common pc ON (pl.item = pc.refname)
    LEFT OUTER JOIN hierarchy hpc ON (pc.id = hpc.id AND hpc.primarytype = 'PlaceitemTenant15')
    LEFT OUTER JOIN utils.placename_hierarchy pn ON (hpc.name = pn.placecsid)
    ORDER BY cc.id, pn.placecsid, ocg.objectcountdate DESC NULLS LAST
$$
LANGUAGE SQL
