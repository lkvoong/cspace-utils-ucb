-- doclist_view, used in CineFiles denorm primary source for searching documents
--
-- CRH 7/31/2014
--
-- this script creates a temporary table, which will be renamed
-- after all of the denorm tables have been successfully created.
--
-- Modified, GLJ 8/2/2014
-- LKV Update collectionobjects_common.numberofobjects to objectcountgroup.objectcount

DROP TABLE IF EXISTS cinefiles_denorm.doclist_viewtmp;

CREATE TABLE cinefiles_denorm.doclist_viewtmp AS
  WITH objects AS (
    SELECT
      co.id,
      CAST(co.objectnumber AS BIGINT) doc_id
    FROM collectionobjects_common co
    JOIN misc m ON (
      co.id = m.id
      AND m.lifecyclestate <> 'deleted')
    WHERE (co.objectnumber ~ '^[0-9]+$' )
    AND co.recordstatus = 'approved'
  )

  SELECT
    objects.doc_id,
    cc.docdisplayname doctitle,
    cinefiles_denorm.getdispl(cc.doctype) doctype,
    ocg.objectcount pages,
    cc.pageinfo pg_info,
    cinefiles_denorm.getdispl(cc.source) source,
    cinefiles_denorm.getshortid(cc.source) src_id,
    das.docauthors author,
    daids.docauthorids as name_id,
    dls.doclanguages doclanguage,
    sdg.datedisplaydate pubdate,
    CASE
      WHEN COALESCE(NULLIF(cc.accesscode, ''), ocf.accesscode) = 'PFA Staff Only' THEN 0
      WHEN COALESCE(NULLIF(cc.accesscode, ''), ocf.accesscode) = 'In House Only' THEN 1
      WHEN COALESCE(NULLIF(cc.accesscode, ''), ocf.accesscode) = 'Campus (UCB)' THEN 2
      WHEN COALESCE(NULLIF(cc.accesscode, ''), ocf.accesscode) = 'Education (.edu)' THEN 3
      WHEN COALESCE(NULLIF(cc.accesscode, ''), ocf.accesscode) = 'World' THEN 4
      WHEN (cc.source is null or cc.source = '') THEN 4
      ELSE NULL END AS code,
    cc.hascastcr AS cast_cr,
    cc.hastechcr AS tech_cr,
    cc.hasboxinfo AS bx_info,
    cc.hasfilmog AS filmog,
    cc.hasdistco AS dist_co,
    cc.hasprodco AS prod_co,
    cc.hascostinfo AS costinfo,
    cc.hasillust AS illust,
    cc.hasbiblio AS biblio,
    rg.referencenote docurl,
    sdg.dateearliestscalarvalue pubdatescalar,
    sdg.datelatestscalarvalue latepubdatescalar,
    wag.webaddress srcUrl,
    dss.docsubjects docsubject,
    dnss.docnamesubjects docnamesubject,
    core.updatedat
  FROM objects
  JOIN collectionspace_core core ON objects.id = core.id
  JOIN collectionobjects_cinefiles cc ON objects.id = cc.id
  LEFT OUTER JOIN hierarchy hocg ON (
    objects.id = hocg.parentid
    AND hocg.primarytype = 'objectCountGroup'
    AND hocg.pos = 0)
  LEFT OUTER JOIN objectcountgroup ocg ON hocg.id = ocg.id
  LEFT OUTER JOIN cinefiles_denorm.doclanguagestring dls ON objects.doc_id = dls.doc_id
  LEFT OUTER JOIN cinefiles_denorm.docauthorstring das ON objects.doc_id = das.doc_id
  LEFT OUTER JOIN hierarchy hsdg ON (
    hsdg.parentid = objects.id
    AND hsdg.name = 'collectionobjects_common:objectProductionDateGroupList'
    AND hsdg.pos = 0)
  LEFT OUTER JOIN structureddategroup sdg ON hsdg.id = sdg.id
  LEFT OUTER JOIN organizations_common oco ON cc.source = oco.refname
  LEFT OUTER JOIN organizations_cinefiles ocf ON oco.id = ocf.id
  LEFT OUTER JOIN hierarchy hrg ON (
    objects.id = hrg.parentid
    AND hrg.primarytype = 'referenceGroup'
    AND hrg.pos = 0)
  LEFT OUTER JOIN referencegroup rg ON hrg.id = rg.id
  LEFT OUTER JOIN hierarchy hcco ON oco.id = hcco.id
  LEFT OUTER JOIN contacts_common cco ON hcco.name = cco.initem
  LEFT OUTER JOIN hierarchy hwag ON (
    cco.id = hwag.parentid
    AND hwag.name = 'contacts_common:webAddressGroupList'
    AND hwag.pos = 0)
  LEFT OUTER JOIN webaddressgroup wag ON hwag.id = wag.id
  LEFT OUTER JOIN cinefiles_denorm.docsubjectstring dss ON objects.doc_id = dss.doc_id
  LEFT OUTER JOIN cinefiles_denorm.docnamesubjectstring dnss ON objects.doc_id = dnss.doc_id
  LEFT OUTER JOIN cinefiles_denorm.docauthoridstring daids ON objects.doc_id = daids.doc_id
  ORDER BY objects.doc_id;

GRANT SELECT ON cinefiles_denorm.doclist_viewtmp TO GROUP reporters_cinefiles;
GRANT SELECT ON cinefiles_denorm.doclist_viewtmp TO reader_cinefiles;

SELECT COUNT(1) FROM cinefiles_denorm.doclist_view;
SELECT COUNT(1) FROM cinefiles_denorm.doclist_viewtmp;
