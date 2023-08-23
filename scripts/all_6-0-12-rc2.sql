-- CSC-2245:
--    grants usage on utils schema to reader_{tenant}
--    grants select on utils schema tables to reader_{tenant}
--    grants default select on utils schema tables to reader_{tenant}
--

-- BEGIN: CSC-2245
--
DO $$
DECLARE
  reader_name VARCHAR;
  nuxeo_name VARCHAR;
  sql_str VARCHAR;
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'utils')
  THEN
    SELECT regexp_replace(current_database(), '^.*_', 'reader_') INTO reader_name;
    SELECT regexp_replace(current_database(), '^.*_', 'nuxeo_') INTO nuxeo_name;

    SELECT FORMAT('GRANT USAGE ON SCHEMA utils TO %I', reader_name) into sql_str;
    EXECUTE sql_str;
    RAISE NOTICE 'Executed: %', sql_str;

    SELECT FORMAT('GRANT SELECT ON ALL TABLES IN SCHEMA utils TO %I', reader_name) into sql_str;
    EXECUTE sql_str;
    RAISE NOTICE 'Executed: %', sql_str;

    SELECT FORMAT('ALTER DEFAULT PRIVILEGES FOR USER %I IN SCHEMA utils
      GRANT SELECT ON TABLES TO %I', nuxeo_name, reader_name) into sql_str;
    EXECUTE sql_str;
    RAISE NOTICE 'Executed: %', sql_str;

  END IF;
END $$;
--
-- END: CSC-2245
