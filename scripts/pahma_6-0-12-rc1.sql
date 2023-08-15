-- pahma_6.0-12.rc1 data updates
--   CSC-2217
--   CSC-2233
--
-- \c pahma_domain_pahma
--
-- CSC-2217: SQL update movements_anthropology_locationhandlers.item to 
--           fix refname for person 'Benjamin Peters', shortid = 7215
--
-- BEGIN PAHMA CSC-2217
--
UPDATE movements_anthropology_locationhandlers
SET item = regexp_replace(item, ' \[died 2008\]', '')
WHERE item ='urn:cspace:pahma.cspace.berkeley.edu:personauthorities:name(person):item:name(7215)''Benjamin Peters [died 2008]''';
--
-- END PAHMA CSC-2217
--
-- CSC-2233: Update assocpeoplegroup.assocpeopletype to convert static values to dynamic assocpeople term list refnames
--
-- BEGIN PAHMA CSC-2233
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
-- END PAHMA CSC-2233
