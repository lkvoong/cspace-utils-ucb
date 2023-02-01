-- filmtitlestring table used in cinefiles denorm
--
-- CRH 2/22/2014
--
-- this script creates a temporary table, which will be renamed
-- after all of the denorm tables have been successfully created.
--
-- Modified GLJ 8/3/2014

DROP TABLE IF EXISTS cinefiles_denorm.filmtitlestringtmp;

CREATE TABLE cinefiles_denorm.filmtitlestringtmp AS
   SELECT
      wc.shortidentifier filmId,
      cinefiles_denorm.findfilmtitles(wc.shortidentifier) filmtitles
   FROM
      works_common wc
      INNER JOIN misc m
         ON (wc.id = m.id AND m.lifecyclestate <> 'deleted')
   -- WHERE cinefiles_denorm.findfilmtitles(wc.shortidentifier) IS NOT NULL
   ORDER BY wc.shortidentifier;

GRANT SELECT ON cinefiles_denorm.filmtitlestringtmp TO GROUP reporters_cinefiles;
GRANT SELECT ON cinefiles_denorm.filmtitlestringtmp TO reader_cinefiles;

SELECT COUNT(1) FROM cinefiles_denorm.filmtitlestring;
SELECT COUNT(1) FROM cinefiles_denorm.filmtitlestringtmp;

