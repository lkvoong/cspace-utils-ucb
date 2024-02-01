/*
CSC-2228 PAHMA: Incorrect refnames in structured date eras
The structuredDateParser is generating incorrect Structured Date Era refnames for shortids 'bce' and 'ce'.

update:
urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(dateera):item:name(bce)'BCE'
urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(dateera):item:name(ce)'CE' 

to:
urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(dateera):item:name(bce)'BC/BCE'
urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(dateera):item:name(ce)'AD/CE' 
*/

-- NOTICE:  Update bce for dateearliestsingleera:
UPDATE structureddategroup
SET dateearliestsingleera = regexp_replace(dateearliestsingleera, 'BCE', 'BC/BCE')
WHERE dateearliestsingleera = 'urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(dateera):item:name(bce)''BCE''';

-- NOTICE:  Update bce for datelatestera:
UPDATE structureddategroup
SET datelatestera = regexp_replace(datelatestera, 'BCE', 'BC/BCE')
WHERE datelatestera = 'urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(dateera):item:name(bce)''BCE''';

-- NOTICE:  Update ce for dateearliestsingleera:
UPDATE structureddategroup
SET dateearliestsingleera = regexp_replace(dateearliestsingleera, 'CE', 'AD/CE')
WHERE dateearliestsingleera = 'urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(dateera):item:name(ce)''CE''';

-- NOTICE:  Update ce for datelatestera:
UPDATE structureddategroup
SET datelatestera = regexp_replace(datelatestera, 'CE', 'AD/CE')
WHERE datelatestera = 'urn:cspace:pahma.cspace.berkeley.edu:vocabularies:name(dateera):item:name(ce)''CE''';

