-- trace_pumps.sql
--
-- Deliver data from source (the ALL_TRACE view) to target (a Hive or Kafka sink, depending on configuration)
-- 
-- Substitution parameters:
--   %HOSTNAME%

SET SCHEMA '"SQLstream_Trace"';

CREATE OR REPLACE PUMP ALL_TRACE_PUMP STOPPED
AS
INSERT INTO ALL_TRACE_SINK
SELECT STREAM '%HOSTNAME%'
     , *
FROM SYS_BOOT.MGMT.ALL_TRACE
;

