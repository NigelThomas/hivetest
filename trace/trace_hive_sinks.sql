-- sinks for sending trace data to hive
--
-- parameters
--  %FILE_ROTATION_TIME% -- wants to be low for latency, high for compression
--  %HOSTNAME%

CREATE FOREIGN STREAM ALL_TRACE_SINK
( "HOSTNAME" VARCHAR(128)
, "ERROR_TIME" TIMESTAMP
, "ERROR_LEVEL" VARCHAR(10)
, "IS_ERROR" BOOLEAN
, "ERROR_CLASS" INTEGER
, "ERROR_NAME" VARCHAR(32)
, "SQL_STATE" VARCHAR(5)
, "MESSAGE" VARCHAR(4096)
, "THREAD_ID" INTEGER
, "SESSION_ID" INTEGER
, "STATEMENT_ID" INTEGER
, "GRAPH_ID" INTEGER
, "NODE_ID" INTEGER
, "XO_NAME" VARCHAR(128)
, "ERROR_REPORTER" VARCHAR(256)
, "ERROR_SQL" VARCHAR(256)
, "ERROR_BACKTRACE" VARCHAR(4096)
, "DATA_ROWTIME" TIMESTAMP
, "DATA_ROW" VARBINARY(32768)
, "SOURCE_POSITION_KEY" VARCHAR(4096)
, "PUMP_DB" VARCHAR(128)
, "PUMP_SCHEMA" VARCHAR(128)
, "PUMP_NAME" VARCHAR(128)
)
SERVER HIVE_SERVER
OPTIONS (
    "FORMATTER" 'ORC',
    "orc.version" 'V_0_11',
    "FILENAME_SUFFIX" '.orc',
    "FILENAME_DATE_FORMAT" 'yyyy-MM-dd-HH.mm.ss',
    "FILE_ROTATION_TIME" '%FILE_ROTATION_TIME%',   
    "FORMATTER_INCLUDE_ROWTIME" 'false',
    "FILE_ROTATION_RESPECT_ROWTIME" 'true'

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
    "AUTH_METASTORE_PRINCIPAL" 'hive/_HOST@GVS.GGN',
    );

