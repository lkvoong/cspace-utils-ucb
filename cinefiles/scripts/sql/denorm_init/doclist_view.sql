-- doclist_view, used in CineFiles denorm as primary source for searching documents
-- CRH 2/23/2014
-- CRH 7/31/2014 adding doc author ids and updatedaat for Mediatrope
-- LKV Update collectionobjects_common.numberofobjects to objectcountgroup.objectcount

-- drop table cinefiles_denorm.doclist_view;

create table cinefiles_denorm.doclist_view as
  with objects as (
    select
      co.id,
      cast(co.objectnumber as bigint) doc_id
    from collectionobjects_common co
    join misc m on (
      co.id = m.id
      and m.lifecyclestate <> 'deleted')
    where (co.objectnumber ~ '^[0-9]+$' )
    and co.recordstatus = 'approved'
  )
  
  select
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
    case
      when coalesce(nullif(cc.accesscode, ''), ocf.accesscode) = 'PFA Staff Only' then 0
      when coalesce(nullif(cc.accesscode, ''), ocf.accesscode) = 'In House Only' then 1
      when coalesce(nullif(cc.accesscode, ''), ocf.accesscode) = 'Campus (UCB)' then 2
      when coalesce(nullif(cc.accesscode, ''), ocf.accesscode) = 'Education (.edu)' then 3
      when coalesce(nullif(cc.accesscode, ''), ocf.accesscode) = 'World' then 4
      when (cc.source is null or cc.source = '') then 4
      else null end as code,
    cc.hascastcr as cast_cr,
    cc.hastechcr as tech_cr,
    cc.hasboxinfo as bx_info, 
    cc.hasfilmog as filmog,
    cc.hasdistco as dist_co,
    cc.hasprodco as prod_co,  
    cc.hascostinfo as costinfo,
    cc.hasillust as illust,
    cc.hasbiblio as biblio,
    rg.referencenote docurl,
    sdg.dateearliestscalarvalue pubdatescalar,
    wag.webaddress srcUrl,
    dss.docsubjects docsubject,
    dnss.docnamesubjects docnamesubject,
    core.updatedat
  from objects
  join collectionspace_core core on objects.id = core.id
  join collectionobjects_cinefiles cc on objects.id = cc.id
  left outer join hierarchy hocg on (
    objects.id = hocg.parentid
    and hocg.primarytype = 'objectCountGroup'
    and hocg.pos = 0)
  left outer join objectcountgroup ocg on hocg.id = ocg.id
  left outer join cinefiles_denorm.doclanguagestring dls on objects.doc_id = dls.doc_id
  left outer join cinefiles_denorm.docauthorstring das on objects.doc_id = das.doc_id
  left outer join hierarchy hsdg on (
    hsdg.parentid = objects.id
    and hsdg.name = 'collectionobjects_common:objectProductionDateGroupList'
    and hsdg.pos = 0)
  left outer join structureddategroup sdg on hsdg.id = sdg.id
  left outer join organizations_common oco on cc.source = oco.refname
  left outer join organizations_cinefiles ocf on oco.id = ocf.id
  left outer join hierarchy hrg on (
    objects.id = hrg.parentid
    and hrg.primarytype = 'referenceGroup'
    and hrg.pos = 0)
  left outer join referencegroup rg on hrg.id = rg.id
  left outer join hierarchy hcco on oco.id = hcco.id
  left outer join contacts_common cco on hcco.name = cco.initem
  left outer join hierarchy hwag on (
    cco.id = hwag.parentid
    and hwag.name = 'contacts_common:webAddressGroupList'
    and hwag.pos = 0)
  left outer join webaddressgroup wag on hwag.id = wag.id
  left outer join cinefiles_denorm.docsubjectstring dss on objects.doc_id = dss.doc_id
  left outer join cinefiles_denorm.docnamesubjectstring dnss on objects.doc_id = dnss.doc_id
  left outer join cinefiles_denorm.docauthoridstring daids on objects.doc_id = daids.doc_id
  order by objects.doc_id;
  
grant select on cinefiles_denorm.doclist_view to group reporters;
grant select on cinefiles_denorm.doclist_view to group cinereaders;
