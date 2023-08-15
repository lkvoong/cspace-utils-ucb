-- CSC-2217: SQL update movements_anthropology_locationhandlers.item to fix refname for person 'Benjamin Peters', shortid = 7215
-- update 
-- 'urn:cspace:pahma.cspace.berkeley.edu:personauthorities:name(person):item:name(7215)''Benjamin Peters [died 2008]'''
-- with
-- 'urn:cspace:pahma.cspace.berkeley.edu:personauthorities:name(person):item:name(7215)''Benjamin Peters'''
--
/*
-- log affected movement records from Prod
--
create temp table csc2217 as
select id, pos
from movements_anthropology_locationhandlers
where item ='urn:cspace:pahma.cspace.berkeley.edu:personauthorities:name(person):item:name(7215)''Benjamin Peters [died 2008]''';
--
-- SELECT 1284

-- COPY id, position of movements_anthropology_locationhandlers records to file
--
\copy csc2217 to '~/CSpace/Jiras/CSC-2217/movements_anthropology_locationhandlers.out'
--
-- COPY 1284
*/

-- BEGIN: update affected records
--
UPDATE movements_anthropology_locationhandlers
SET item = regexp_replace(item, ' \[died 2008\]', '')
WHERE item ='urn:cspace:pahma.cspace.berkeley.edu:personauthorities:name(person):item:name(7215)''Benjamin Peters [died 2008]''';
--
-- END: update affected records
