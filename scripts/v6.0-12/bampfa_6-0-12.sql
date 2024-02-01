-- bampfa_6.0-12.rc1 data updates
--   CSC-2191
--
-- \c pahma_domain_pahma
--
-- CSC-2191: Update collectionobjects_bampfa_acquisitionsources to person/org refnames
--
-- \c bampfa_domain_bampfa
--
-- BEGIN BAMPFA CSC-2191
--
-- create temp table to hold data of affected records
--
create temp table csc2191 as
with person_org as (
  select
    otg.termdisplayname as source_name,
    oc.refname
  from orgtermgroup otg
  join hierarchy hotg on (otg.id = hotg.id)
  join organizations_common oc on (hotg.parentid = oc.id)
  join misc moc on (oc.id = moc.id and moc.lifecyclestate <> 'deleted')
  join (select distinct item from collectionobjects_bampfa_acquisitionsources) cba
    on (otg.termdisplayname = cba.item)
  union
  select
    ptg.termdisplayname as source_name,
    pc.refname
  from persontermgroup ptg
  join hierarchy hptg on (ptg.id = hptg.id)
  join persons_common pc on (hptg.parentid = pc.id)
  join misc mpc on (pc.id = mpc.id and mpc.lifecyclestate <> 'deleted')
  join (select distinct item from collectionobjects_bampfa_acquisitionsources) cba
    on (ptg.termdisplayname = cba.item)
)
select distinct cba.item, po.refname
from collectionobjects_bampfa_acquisitionsources cba
join misc m on (cba.id = m.id)
join person_org po on (cba.item = po.source_name)
where m.lifecyclestate != 'deleted';

-- update collectionobjects_bampfa_acquisitionsources.item to person/org refname
--
update collectionobjects_bampfa_acquisitionsources s
set item = csc2191.refname
from csc2191
where s.item = csc2191.item;
--
-- END BAMPFA CSC-2191
