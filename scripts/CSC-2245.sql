-- CSC-2245: grant usage on utils schema to reader_{tenant}
--

-- BEGIN: CSC-2245
--
DO $$
DECLARE
  reader_name VARCHAR;
  sql_str VARCHAR;
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'utils')
  THEN
    SELECT regexp_replace(current_database(), '^.*_', 'reader_') INTO reader_name;

    SELECT FORMAT('GRANT USAGE ON SCHEMA utils TO %I', reader_name) into sql_str;

    RAISE NOTICE 'Executed: %', sql_str;

    EXECUTE sql_str;
  END IF;
END $$;
--
-- END: CSC-2245
