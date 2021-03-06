set lin 400;
set feedback off;
set verify off;

prompt ========================================
prompt Installing IOD_SPM
prompt ========================================

prompt granting PRIVILEGES to &&1.
@@grants.sql

prompt sets library version
@@version.sql

DEF conditional_skip = '';
COL conditional_skip NEW_V conditional_skip NOPRI;
SELECT CASE COUNT(*) WHEN 2 THEN '--skip--' END conditional_skip 
  FROM dba_source
 WHERE owner = UPPER(TRIM('&&1.')) 
   AND name = 'IOD_SPM'
   AND line <= 3 
   AND type LIKE 'PACKAGE%' 
   AND text LIKE '%Header%'
   AND text LIKE '%&&library_version.%'
/

prompt creating objects
@@objects.sql

prompt compiling package specification (if there is a new version)
@@&&conditional_skip.iod_spm.pks.sql
SHOW ERRORS PACKAGE &&1..iod_spm;

prompt compiling package body (if there is a new version)
@@&&conditional_skip.iod_spm.pkb.sql
SHOW ERRORS PACKAGE BODY &&1..iod_spm;
