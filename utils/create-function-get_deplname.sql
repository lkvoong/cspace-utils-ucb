CREATE OR REPLACE FUNCTION utils.get_deplname()
 RETURNS character varying
 LANGUAGE plpgsql
 IMMUTABLE STRICT
AS $function$

DECLARE namestr VARCHAR(20);

BEGIN

SELECT 
  -- old servername format: cs-ucb-(qa|prod)-db.lyrtech.org
  -- new servername format: cspace-ucb-(qa|production)
  REGEXP_REPLACE(REGEXP_REPLACE(current_database(), '[_].*$', ''), 'botgarden', 'ucbg') || 
  CASE WHEN REGEXP_REPLACE(name, '^.*-(qa)-?.*$', '\1') = 'qa' THEN '.qa' ELSE '' END
INTO namestr
FROM utils.servername;

RETURN namestr;

END;

$function$


GRANT EXECUTE ON FUNCTION utils.getdeplname() TO PUBLIC;
