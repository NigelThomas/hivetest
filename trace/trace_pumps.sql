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
( "hostname"
, "error_time"
, "error_level"
, "is_error"
, "error_class"
, "error_name"
, "sql_state"
, "message"
, "thread_id"
, "session_id"
, "statement_id"
, "graph_id"
, "node_id"
, "xo_name"
, "error_reporter"
, "error_sql"
, "error_backtrace"
, "data_rowtime"
--, "data_row"
, "source_position_key"
, "pump_db"
, "pump_schema"
, "pump_name"
)
SELECT STREAM CAST('%HOSTNAME%' as VARCHAR(128))
, "ERROR_TIME"
, "ERROR_LEVEL"
, "IS_ERROR"
, "ERROR_CLASS"
, "ERROR_NAME"
, "SQL_STATE"
, "MESSAGE"
, "THREAD_ID"
, "SESSION_ID"
, "STATEMENT_ID"
, "GRAPH_ID"
, "NODE_ID"
, "XO_NAME"
, "ERROR_REPORTER"
, "ERROR_SQL"
, "ERROR_BACKTRACE"
, "DATA_ROWTIME"
--, "DATA_ROW"
, "SOURCE_POSITION_KEY"
, "PUMP_DB"
, "PUMP_SCHEMA"
, "PUMP_NAME"

FROM SYS_BOOT.MGMT.ALL_TRACE
;

