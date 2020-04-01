-- sinks for sending trace data to hive
--
-- parameters
--  %FILE_ROTATION_TIME% -- wants to be low for latency, high for compression
--  %HOSTNAME%

CREATE OR REPLACE SCHEMA "SQLstream_Trace";
SET SCHEMA '"SQLstream_Trace"';

CREATE FOREIGN STREAM ALL_TRACE_SINK
( "hostname" varchar(128)
, "error_time" timestamp
, "error_level" varchar(10)
, "is_error" boolean
, "error_class" integer
, "error_name" varchar(32)
, "sql_state" varchar(5)
, "message" varchar(4096)
, "thread_id" integer
, "session_id" integer
, "statement_id" integer
, "graph_id" integer
, "node_id" integer
, "xo_name" varchar(128)
, "error_reporter" varchar(256)
, "error_sql" varchar(256)
, "error_backtrace" varchar(4096)
, "data_rowtime" timestamp
--, "data_row" varbinary(32768)         -- varbinary not supported by hive
, "source_position_key" varchar(4096)
, "pump_db" varchar(128)
, "pump_schema" varchar(128)
, "pump_name" varchar(128)
)
SERVER HIVE_SERVER
OPTIONS (
    "FORMATTER" 'ORC',
    "orc.version" 'V_0_11',
    "FILENAME_SUFFIX" '.orc',
    "FILENAME_DATE_FORMAT" 'yyyy-MM-dd-HH.mm.ss',
    "FILE_ROTATION_TIME" '%FILE_ROTATION_TIME%',   
    "FORMATTER_INCLUDE_ROWTIME" 'false',
    "FILE_ROTATION_RESPECT_ROWTIME" 'true',

    -- these are the table-specific options

    "DIRECTORY" '/home/sqlstream/trace/alltrace',
    "FILENAME_PREFIX" 'trace-out-%HOSTNAME%',
    "ORIGINAL_FILENAME" 'pending-trace.orc',

    "HDFS_OUTPUT_DIR" '/data/svc_sqlstream_guavus/trace/alltrace', 

    "HIVE_SCHEMA_NAME" 'sqlstream_trace',
    "HIVE_TABLE_NAME" 'all_trace',

    -- these are HDFS / Hive server options

    "HIVE_URI" 'jdbc:hive2://sqlstream01-slv-01.cloud.in.guavus.com:2181,sqlstream01-slv-02.cloud.in.guavus.com:2181,sqlstream01-slv-03.cloud.in.guavus.com:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2-hive2',
    "HIVE_METASTORE_URIS" 'thrift://sqlstream01-mst-01.cloud.in.guavus.com:9083,thrift://sqlstream01-mst-02.cloud.in.guavus.com:9083',
    "CONFIG_PATH" '/home/sqlstream/core-site.xml:/home/sqlstream/hdfs-site.xml',
    "AUTH_METHOD" 'kerberos',
    "AUTH_USERNAME" 'svc_sqlstream_guavus@GVS.GGN',
    "AUTH_KEYTAB" '/home/sqlstream/svc_sqlstream_guavus.keytab',
    "AUTH_METASTORE_PRINCIPAL" 'hive/_HOST@GVS.GGN'
    );

