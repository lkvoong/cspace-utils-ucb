-- CSC-2245: update utils schema and table privs for reader_{tenant}
--

-- BEGIN: CSC-2245
--
DO $$
DECLARE
  tenant_name VARCHAR;
  reader_name VARCHAR;
  nuxeo_name VARCHAR;
  sql_str VARCHAR;
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'utils')
  THEN
    SELECT regexp_replace(current_database(), '_.*', '') INTO tenant_name;
    reader_name := 'reader_' || tenant_name;
    nuxeo_name := 'nuxeo_' || tenant_name;

    RAISE NOTICE 'tenant value: %', tenant_name;
    RAISE NOTICE 'reader value: %', reader_name;
    RAISE NOTICE 'nuxeo value: %', nuxeo_name;

    SELECT FORMAT('GRANT USAGE ON SCHEMA utils TO %I', reader_name) into sql_str;
    RAISE NOTICE 'sql_str value: %', sql_str;
    EXECUTE sql_str;

    SELECT FORMAT('GRANT SELECT ON ALL TABLES IN SCHEMA utils TO %I', reader_name) into sql_str;
    RAISE NOTICE 'sql_str value: %', sql_str;
    EXECUTE sql_str;

    SELECT FORMAT('GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA utils TO %I', reader_name) into sql_str;
    RAISE NOTICE 'sql_str value: %', sql_str;
    EXECUTE sql_str;

    SELECT FORMAT('ALTER DEFAULT PRIVILEGES FOR USER %I IN SCHEMA utils
      GRANT SELECT ON TABLES TO %I', nuxeo_name, reader_name) into sql_str;
    RAISE NOTICE 'sql_str value: %', sql_str;
    EXECUTE sql_str;

    SELECT FORMAT('ALTER DEFAULT PRIVILEGES FOR USER %I IN SCHEMA utils
      GRANT EXECUTE ON FUNCTIONS TO %I', nuxeo_name, reader_name) into sql_str;
    RAISE NOTICE 'sql_str value: %', sql_str;
    EXECUTE sql_str;

  END IF;
END $$;
--
-- END: CSC-2245
