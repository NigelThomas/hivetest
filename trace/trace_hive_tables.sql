-- definition for trace table in hive
-- to be executed using beeline

-- NOTE: LOCATION for these tables must match HDFS_OUTPUT_DIR for SQLstream sink foreign streams

!set force on
CREATE SCHEMA sqlstream_trace;
!set force off


USE sqlstream_trace;

create external table all_trace
( hostname varchar(128)
, error_time timestamp
, error_level varchar(10)
, is_error boolean
, error_class int
, error_name varchar(32)
, sql_state varchar(5)
, message varchar(4096)
, thread_id int
, session_id int
, statement_id int
, graph_id int
, node_id int
, xo_name varchar(128)
, error_reporter varchar(256)
, error_sql varchar(256)
, error_backtrace varchar(4096)
, data_rowtime timestamp
-- varbinary not supported, data_row varbinary(32768)
, source_position_key varchar(4096)
, pump_db varchar(128)
, pump_schema varchar(128)
, pump_name varchar(128)
)
STORED AS ORC
LOCATION '/data/svc_sqlstream_guavus/trace/alltrace'
TBLPROPERTIES
( "orc.compress" = "SNAPPY"
);
