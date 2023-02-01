-- originaljpegs table used by CineFiles denorm
--
-- this script creates the originaljpegs table in cinefiles_denorm
--
-- Modified GLJ 12/15/2014

TRUNCATE TABLE ONLY cinefiles_denorm.originaljpegs;

INSERT INTO cinefiles_denorm.originaljpegs
   ( SELECT csid, md5, contentname, nameparts[2], filename, updatedat
     FROM cinefiles_denorm.originaljpegs_view );

