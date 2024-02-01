-- CSC-2233
-- Update assocpeoplegroup.assocpeopletype to refnames from assocpeople vocabulary

/*
-- check data in Prod

select count(*), assocpeopletype from assocpeoplegroup where assocpeopletype in (
  'gatheredCollectedBy',
  'inspiredBy',
  'nagpraCulturalAffiliation',
  'traditionalMakers',
  'inTheStyleOf',
  'attributedMakers',
  'made by',
  'traditionallyMadeBy',
  'usedButNotMadeBy',
  'usedButNotMadeByAttributed')
group by assocpeopletype;

 count |      assocpeopletype       
-------+----------------------------
  2074 | attributedMakers
     2 | gatheredCollectedBy
   227 | inspiredBy
    62 | inTheStyleOf
 10723 | made by
    80 | nagpraCulturalAffiliation
     9 | traditionallyMadeBy
    14 | traditionalMakers
    28 | usedButNotMadeBy
    21 | usedButNotMadeByAttributed
(10 rows)

select count(*), assocpeopletype from assocpeoplegroup where assocpeopletype not in (
'gatheredCollectedBy',
'inspiredBy',
'nagpraCulturalAffiliation',
'traditionalMakers',
'inTheStyleOf',
'attributedMakers',
'made by',
'traditionallyMadeBy',
'usedButNotMadeBy',
'usedButNotMadeByAttributed')
group by assocpeopletype;

 count  |                                                            assocpeopletype                                                            
--------+---------------------------------------------------------------------------------------------------------------------------------------
      9 | urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(assocpeople):item:name(assocpeopletype00)'gathered/collected by'
    125 | urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(assocpeople):item:name(assocpeopletype01)'inspired by'
  20843 | urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(assocpeople):item:name(assocpeopletype02)'NAGPRA cultural affiliation'
     16 | urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(assocpeople):item:name(assocpeopletype03)'traditional makers'
     20 | urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(assocpeople):item:name(assocpeopletype04)'in the style of'
   1583 | urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(assocpeople):item:name(assocpeopletype05)'made by (attributed)'
 171049 | urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(assocpeople):item:name(assocpeopletype06)'made by'
      4 | urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(assocpeople):item:name(assocpeopletype07)'traditionally made by'
     39 | urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(assocpeople):item:name(assocpeopletype08)'used, but not made, by'
      4 | urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(assocpeople):item:name(assocpeopletype09)'used, but not made, by (attributed)'
(10 rows)
*/

-- BEGIN: Update assocpeoplegroup.assocpeopletype to convert static option list values to dynamic assocpeople term list refnames
--

UPDATE assocpeoplegroup
  SET assocpeopletype = 'urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(assocpeople):item:name(assocpeopletype00)''gathered/collected by'''
  WHERE assocpeopletype = 'gatheredCollectedBy';

UPDATE assocpeoplegroup
  SET assocpeopletype = 'urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(assocpeople):item:name(assocpeopletype01)''inspired by'''
  WHERE assocpeopletype = 'inspiredBy';

UPDATE assocpeoplegroup
  SET assocpeopletype = 'urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(assocpeople):item:name(assocpeopletype02)''NAGPRA cultural affiliation'''
  WHERE assocpeopletype = 'nagpraCulturalAffiliation';

UPDATE assocpeoplegroup
  SET assocpeopletype = 'urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(assocpeople):item:name(assocpeopletype03)''traditional makers'''
  WHERE assocpeopletype = 'traditionalMakers';

UPDATE assocpeoplegroup
  SET assocpeopletype = 'urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(assocpeople):item:name(assocpeopletype04)''in the style of'''
  WHERE assocpeopletype = 'inTheStyleOf';

UPDATE assocpeoplegroup
  SET assocpeopletype = 'urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(assocpeople):item:name(assocpeopletype05)''made by (attributed)'''
  WHERE assocpeopletype = 'attributedMakers';

UPDATE assocpeoplegroup
  SET assocpeopletype = 'urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(assocpeople):item:name(assocpeopletype06)''made by'''
  WHERE assocpeopletype = 'made by';

UPDATE assocpeoplegroup
  SET assocpeopletype = 'urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(assocpeople):item:name(assocpeopletype07)''traditionally made by'''
  WHERE assocpeopletype = 'traditionallyMadeBy';

UPDATE assocpeoplegroup
  SET assocpeopletype = 'urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(assocpeople):item:name(assocpeopletype08)''used, but not made, by'''
  WHERE assocpeopletype = 'usedButNotMadeBy';

UPDATE assocpeoplegroup
  SET assocpeopletype = 'urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(assocpeople):item:name(assocpeopletype09)''used, but not made, by (attributed)'''
  WHERE assocpeopletype = 'usedButNotMadeByAttributed';

--
-- END: Update assocpeoplegroup.assocpeopletype to convert static option list values to dynamic assocpeople term list refnames
