/* Function gets PAHMA NAGPRA Repatriation Compliance data for a single collection object.
 * Used in the pahmapahmaRepatriationNAGPRAdenorm.jrxml report.
 * Must created TYPE nagpratype before creating this function.
 *
 * Usage:
 *   select utils.getnagpra('2dbcbf18-4966-4178-9880-e81258568921')
 *
 *   select * from utils.getnagpra('2dbcbf18-4966-4178-9880-e81258568921')
 *
 *   select utils.getnagpra(id) from collectionobjects_common 
 *   where id in ('8cbd1864-5212-44af-9d69-512829e5a3e3', '2dbcbf18-4966-4178-9880-e81258568921')
 *
 *   select (n).* from (
 *       select utils.getnagpra(h.id) as n from hierarchy h
 *       where h.name in ('27c11fff-d74c-45dc-949c', '8cea428c-d3a5-4093-bcdb')) x
 *   order by (n).objectnumber, (n).pos
 */

-- DROP FUNCTION IF EXISTS utils.getnagpra (cocid VARCHAR);

--
-- Name: getnagpra(character varying); Type: FUNCTION; Schema: utils; Owner: nuxeo_pahma
--

CREATE OR REPLACE FUNCTION utils.getnagpra (cocid VARCHAR)
RETURNS SETOF utils.nagpratype
AS
$$

DECLARE
    updsql   text;
    t        varchar[];
    reptabs  varchar[] := array[['collectionobjects_pahma_pahmaobjectstatuslist', 'objectStatus']
                             , ['collectionobjects_nagpra_nagprainventorynames', 'nagpraInventoryName']
                             , ['collectionobjects_nagpra_nagpracategories', 'nagpraCategory']
                             , ['collectionobjects_nagpra_graveassoccodes', 'graveAssocCode']
                             , ['collectionobjects_nagpra_repatriationnotes', 'repatriationNote']
                             , ['collectionobjects_nagpra_nagpraculturaldeterminations', 'nagpraCulturalDetermination']];
    updcol   text;
    col      varchar;
    tempcols varchar[] := array['pos',
                                'objectNumber',
                                'sortableObjectNumber',
                                'objectStatus',
                                'nagpraInventoryName',
                                'nagpraCategory',
                                'graveAssocCode',
                                'repatriationNote',
                                'nagpraCulturalDetermination',
                                'nagpraDetermCulture',
                                'nagpraDetermType',
                                'nagpraDetermBy',
                                'nagpraDetermNote',
                                'nagpraReportFiled',
                                'nagpraReportFiledWith',
                                'nagpraReportFiledBy',
                                'nagpraReportFiledDate',
                                'nagpraReportFiledNote',
                                'reference',
                                'referenceNote'];

BEGIN

    DROP TABLE IF EXISTS getnagpra_temp;

    -- create temp table for processed data
    CREATE TEMP TABLE getnagpra_temp (
        cocsid varchar,
        coid varchar,
        pos varchar,
        objectNumber varchar,
        sortableObjectNumber varchar,
        objectStatus varchar,
        nagpraInventoryName varchar,
        nagpraCategory varchar,
        graveAssocCode varchar,
        repatriationNote varchar,
        nagpraCulturalDetermination varchar,
        nagpraDetermCulture varchar,
        nagpraDetermType varchar,
        nagpraDetermBy varchar,
        nagpraDetermNote varchar,
        nagpraReportFiled varchar,
        nagpraReportFiledWith varchar,
        nagpraReportFiledBy varchar,
        nagpraReportFiledDate varchar,
        nagpraReportFiledNote varchar,
        reference varchar,
        referenceNote varchar
    );
    
    -- get unique positions for repeating fields/groups.
    INSERT INTO getnagpra_temp (coid, pos)
    SELECT id, pos::varchar FROM collectionobjects_pahma_pahmaobjectstatuslist WHERE id = cocid
    UNION
    SELECT id, pos::varchar FROM collectionobjects_nagpra_nagprainventorynames WHERE id = cocid
    UNION
    SELECT id, pos::varchar FROM collectionobjects_nagpra_nagpracategories WHERE id = cocid
    UNION
    SELECT id, pos::varchar FROM collectionobjects_nagpra_graveassoccodes WHERE id = cocid
    UNION
    SELECT id, pos::varchar FROM collectionobjects_nagpra_repatriationnotes WHERE id = cocid
    UNION
    SELECT id, pos::varchar FROM collectionobjects_nagpra_nagpraculturaldeterminations WHERE id = cocid
    UNION
    SELECT parentid, pos::varchar FROM hierarchy WHERE parentid = cocid AND primarytype = 'nagpraDetermGroup'
    UNION
    SELECT parentid, pos::varchar FROM hierarchy WHERE parentid = cocid AND primarytype = 'nagpraReportFiledGroup'
    UNION
    SELECT parentid, pos::varchar FROM hierarchy WHERE parentid = cocid AND primarytype = 'referenceGroup';

    -- get csid, objectnumber, sortableobjectnumber for collection object record.
    UPDATE getnagpra_temp SET cocsid = h.name FROM hierarchy h WHERE getnagpra_temp.coid = h.id;

    UPDATE getnagpra_temp SET objectNumber = c.objectnumber FROM collectionobjects_common c WHERE getnagpra_temp.coid = c.id;

    UPDATE getnagpra_temp SET sortableobjectnumber = c.sortableobjectnumber FROM collectionobjects_pahma c WHERE getnagpra_temp.coid = c.id;
    
    -- get displaynames for refnames in repeating fields
    FOREACH t SLICE 1 IN ARRAY reptabs LOOP
    
        updsql := 'UPDATE getnagpra_temp SET '|| t[2] || ' = getdispl(n.item) ' ||
                  'FROM ' || t[1] || ' n ' ||
                  'WHERE getnagpra_temp.coid = n.id AND getnagpra_temp.pos = n.pos::varchar;';

        --RAISE NOTICE 'updsql for %: %', t[1], updsql;

        EXECUTE updsql;

    END LOOP;
    
    -- get displaynames/notes for nagpraDetermGroup data.
    UPDATE getnagpra_temp
    SET nagpraDetermCulture = getdispl(n.nagpradetermculture),
        nagpraDetermType = getdispl(n.nagpradetermtype),
        nagpraDetermBy = getdispl(n.nagpradetermby),
        nagpraDetermNote = n.nagpradetermnote
    FROM nagpradetermgroup n join hierarchy h on (n.id = h.id)
    WHERE getnagpra_temp.coid = h.parentid
    AND h.primarytype = 'nagpraDetermGroup'
    AND getnagpra_temp.pos = h.pos::varchar;

    -- get displaynames/notes for nagpraReportFiledGroup data.
    UPDATE getnagpra_temp
    SET nagpraReportFiled = n.nagprareportfiled::text,
        nagpraReportFiledWith = getdispl(n.nagprareportfiledwith),
        nagpraReportFiledBy = getdispl(n.nagprareportfiledby),
        nagpraReportFiledNote = n.nagprareportfilednote
    FROM nagprareportfiledgroup n join hierarchy h on (n.id = h.id)
    WHERE getnagpra_temp.coid = h.parentid
    AND h.primarytype = 'nagpraReportFiledGroup'
    AND getnagpra_temp.pos = h.pos::varchar;

    -- get displaydate for nagpraReportFiledGroup data.
    UPDATE getnagpra_temp
    SET nagpraReportFiledDate = s.datedisplaydate
    FROM hierarchy hn join hierarchy hs on (hn.id = hs.parentid)
    join structureddategroup s on (hs.id = s.id)
    WHERE getnagpra_temp.coid = hn.parentid
    AND hs.name = 'nagpraReportFiledDate';

    -- get displaynames/notes for referenceGroup data.
    UPDATE getnagpra_temp
    SET reference = getdispl(n.reference),
        referenceNote = n.referencenote
    FROM referencegroup n join hierarchy h on (n.id = h.id)
    WHERE getnagpra_temp.coid = h.parentid
    AND h.primarytype = 'referenceGroup'
    AND getnagpra_temp.pos = h.pos::varchar;

    -- convert returns and newlines to '\n'.
    UPDATE getnagpra_temp SET
        repatriationNote = regexp_replace(repatriationNote, E'[\n\r]+', '\n', 'g'),
        nagpraCulturalDetermination = regexp_replace(nagpraCulturalDetermination, E'[\n\r]+', '\n', 'g');

    FOREACH col in ARRAY tempcols LOOP
        updcol := 'UPDATE getnagpra_temp SET ' || col || ' = ''%NULLVALUE%'' ' ||
                           'WHERE ' || col || ' is NULL;';

        EXECUTE updcol;
 
    END LOOP;

    RETURN QUERY SELECT * FROM getnagpra_temp;

END;

$$
LANGUAGE 'plpgsql'
RETURNS NULL ON NULL INPUT;

-- OWNER TO nuxeo_pahma
ALTER FUNCTION utils.getnagpra(cocid character varying) OWNER TO nuxeo_pahma;

-- EXECUTE TO public
GRANT EXECUTE ON FUNCTION utils.getnagpra (cocid VARCHAR) TO public;

