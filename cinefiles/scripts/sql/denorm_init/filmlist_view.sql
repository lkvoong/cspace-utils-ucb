-- filmlist_view.sql, used in cinefiles_denorm
-- gets concatenated strings for repeating information insteaad of cartesian products
-- CRH 2/23/2014
-- CRH 7/31/2014 adding production company identifiers and updatedat for Mediatrope
-- LKV 9/18/2025 remove unused joins to hierarchy and cinefiles_denorm.filmyearstring

-- drop table cinefiles_denorm.filmlist_view

CREATE table cinefiles_denorm.filmlist_view AS
SELECT
  wc.shortidentifier film_id,
  fdids.filmdirectorids name_id,
  fdc.doccount doc_count,
  cinefiles_denorm.concat_worktitles(wc.shortidentifier) filmtitle,
  fcs.filmcountries country,
  cast(sdg.dateearliestsingleyear as int) filmYear,
  fds.filmdirectors director,
  fls.filmlanguages filmlanguage,
  fps.filmprodcos prodco,
  fss.filmsubjects subject,
  fgs.filmgenres genre,
  fts.filmtitles title,
  fpids.filmprodcoids prodco_id,
  core.updatedat
FROM works_common wc
JOIN misc m ON (
  wc.id = m.id
  AND m.lifecyclestate <> 'deleted')
JOIN collectionspace_core core ON wc.id = core.id
LEFT OUTER JOIN cinefiles_denorm.filmdirectorstring fds ON wc.shortidentifier = fds.filmid
LEFT OUTER JOIN cinefiles_denorm.filmdirectoridstring fdids ON wc.shortidentifier = fdids.filmid
LEFT OUTER JOIN cinefiles_denorm.filmcountrystring fcs ON wc.shortidentifier = fcs.filmid
LEFT OUTER JOIN hierarchy hwdg ON (
  wc.id = hwdg.parentid
  AND hwdg.name = 'works_common:workDateGroupList') 
LEFT OUTER JOIN structureddategroup sdg ON hwdg.id = sdg.id
LEFT OUTER JOIN cinefiles_denorm.filmlanguagestring fls ON wc.shortidentifier = fls.filmid
LEFT OUTER JOIN cinefiles_denorm.filmsubjectstring fss ON wc.shortidentifier = fss.filmid
LEFT OUTER JOIN cinefiles_denorm.filmgenrestring fgs ON wc.shortidentifier = fgs.filmid
LEFT OUTER JOIN cinefiles_denorm.filmtitlestring fts ON wc.shortidentifier = fts.filmid
LEFT OUTER JOIN cinefiles_denorm.filmprodcostring fps ON wc.shortidentifier = fps.filmid
LEFT OUTER JOIN cinefiles_denorm.filmdoccount fdc ON wc.shortidentifier = fdc.filmid
LEFT OUTER JOIN cinefiles_denorm.filmprodcoidstring fpids ON wc.shortidentifier = fpids.filmid
WHERE fdc.doccount IS NOT NULL
ORDER BY wc.shortidentifier;

GRANT SELECT ON cinefiles_denorm.filmlist_view TO GROUP reporters;
GRANT SELECT ON cinefiles_denorm.filmlist_view TO GROUP cinereaders;
