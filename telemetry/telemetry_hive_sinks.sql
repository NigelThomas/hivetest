-- Sink foreign streams for Hive output
--
-- parameters
--  %FILE_ROTATION_TIME% -- wants to be low for latency, high for compression
--  %HOSTNAME%

CREATE OR REPLACE SCHEMA "SQLstream_Telemetry";
SET SCHEMA '"SQLstream_Telemetry"';

create or replace FOREIGN STREAM TELEMETRY_SERVER_SINK
("HOSTNAME" VARCHAR(128)
,"MEASURED_AT" TIMESTAMP
,"IS_RUNNING" BOOLEAN
,"IS_LICENSED" BOOLEAN
,"LICENSE_KIND" VARCHAR(32)
,"LICENSE_VERSION" VARCHAR(32)
,"IS_THROTTLED" BOOLEAN
,"NUM_SESSIONS" INTEGER
,"NUM_STATEMENTS" INTEGER
,"STARTED_AT" TIMESTAMP
,"THROTTLED_AT" TIMESTAMP
,"THROTTLE_LEVEL" DOUBLE
,"NUM_EXEC_THREADS" INTEGER
,"NUM_STREAM_GRAPHS_OPEN" INTEGER
,"NUM_STREAM_GRAPHS_CLOSED" INTEGER
,"NUM_STREAM_OPERATORS" INTEGER
,"NUM_STREAM_GRAPHS_OPEN_EVER" INTEGER
,"NUM_STREAM_GRAPHS_CLOSED_EVER" INTEGER
,"NET_MEMORY_BYTES" BIGINT
,"MAX_MEMORY_BYTES" BIGINT
,"USAGE_AT" TIMESTAMP
,"USAGE_SINCE" TIMESTAMP
,"USAGE_REPORTED_AT" TIMESTAMP
,"NET_INPUT_BYTES" BIGINT
,"NET_OUTPUT_BYTES" BIGINT
,"NET_INPUT_BYTES_TODAY" BIGINT
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

    "DIRECTORY" '/home/sqlstream/telemetry/server',
    "FILENAME_PREFIX" 'server-out-%HOSTNAME%',
    "ORIGINAL_FILENAME" 'pending-server.orc',

    "HDFS_OUTPUT_DIR" '/data/svc_sqlstream_guavus/telemetry/server', 

    "HIVE_SCHEMA_NAME" 'sqlstream_telemetry',
    "HIVE_TABLE_NAME" 'telemetry_server_info',

    -- these are HDFS / Hive server options

    "HIVE_URI" 'jdbc:hive2://sqlstream01-slv-01.cloud.in.guavus.com:2181,sqlstream01-slv-02.cloud.in.guavus.com:2181,sqlstream01-slv-03.cloud.in.guavus.com:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2-hive2',
    "HIVE_METASTORE_URIS" 'thrift://sqlstream01-mst-01.cloud.in.guavus.com:9083,thrift://sqlstream01-mst-02.cloud.in.guavus.com:9083',
    "CONFIG_PATH" '/home/sqlstream/core-site.xml:/home/sqlstream/hdfs-site.xml',
    "AUTH_METHOD" 'kerberos',
    "AUTH_USERNAME" 'svc_sqlstream_guavus@GVS.GGN',
    "AUTH_KEYTAB" '/home/sqlstream/svc_sqlstream_guavus.keytab',
    "AUTH_METASTORE_PRINCIPAL" 'hive/_HOST@GVS.GGN',
    );


create or replace FOREIGN STREAM TELEMETRY_STREAM_GRAPH_SINK
("HOSTNAME" VARCHAR(128)
,"MEASURED_AT" TIMESTAMP
,"GRAPH_ID" INTEGER
,"STATEMENT_ID" INTEGER
,"SESSION_ID" INTEGER
,"SOURCE_SQL" VARCHAR(2048)
,"SCHED_STATE" CHAR(1)
,"CLOSE_MODE" CHAR(6)
,"IS_GLOBAL_NEXUS" BOOLEAN
,"IS_AUTO_CLOSE" BOOLEAN
,"NUM_NODES" INTEGER
,"NUM_LIVE_NODES" INTEGER
,"NUM_DATA_BUFFERS" INTEGER
,"TOTAL_EXECUTION_TIME" DOUBLE
,"TOTAL_OPENING_TIME" DOUBLE
,"TOTAL_CLOSING_TIME" DOUBLE
,"NET_INPUT_BYTES" BIGINT
,"NET_INPUT_ROWS" BIGINT
,"NET_INPUT_RATE" DOUBLE
,"NET_INPUT_ROW_RATE" DOUBLE
,"NET_OUTPUT_BYTES" BIGINT
,"NET_OUTPUT_ROWS" BIGINT
,"NET_OUTPUT_RATE" DOUBLE
,"NET_OUTPUT_ROW_RATE" DOUBLE
,"NET_MEMORY_BYTES" BIGINT
,"MAX_MEMORY_BYTES" BIGINT
,"WHEN_OPENED" TIMESTAMP
,"WHEN_STARTED" TIMESTAMP
,"WHEN_FINISHED" TIMESTAMP
,"WHEN_CLOSED" TIMESTAMP
)
OPTIONS (
    "FORMATTER" 'CSV',
    "orc.version" 'V_0_11',
    "FILENAME_SUFFIX" '.orc',
    "FILENAME_DATE_FORMAT" 'yyyy-MM-dd-HH.mm.ss',
    "FILE_ROTATION_TIME" '%FILE_ROTATION_TIME%',   
    "FORMATTER_INCLUDE_ROWTIME" 'false',
    "FILE_ROTATION_RESPECT_ROWTIME" 'true'

    -- these are the table-specific options

    "DIRECTORY" '/home/sqlstream/telemetry/streamgraph',
    "FILENAME_PREFIX" 'streamgraph-out-%HOSTNAME%',
    "ORIGINAL_FILENAME" 'pending-streamgraph.orc',

    "HDFS_OUTPUT_DIR" '/data/svc_sqlstream_guavus/telemetry/streamop', 

    "HIVE_SCHEMA_NAME" 'sqlstream_telemetry',
    "HIVE_TABLE_NAME" 'telemetry_stream_graph_info',

    -- these are HDFS / Hive server options

    "HIVE_URI" 'jdbc:hive2://sqlstream01-slv-01.cloud.in.guavus.com:2181,sqlstream01-slv-02.cloud.in.guavus.com:2181,sqlstream01-slv-03.cloud.in.guavus.com:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2-hive2',
    "HIVE_METASTORE_URIS" 'thrift://sqlstream01-mst-01.cloud.in.guavus.com:9083,thrift://sqlstream01-mst-02.cloud.in.guavus.com:9083',
    "CONFIG_PATH" '/home/sqlstream/core-site.xml:/home/sqlstream/hdfs-site.xml',
    "AUTH_METHOD" 'kerberos',
    "AUTH_USERNAME" 'svc_sqlstream_guavus@GVS.GGN',
    "AUTH_KEYTAB" '/home/sqlstream/svc_sqlstream_guavus.keytab',
    "AUTH_METASTORE_PRINCIPAL" 'hive/_HOST@GVS.GGN',
    );



CREATE OR REPLACE FOREIGN STREAM TELEMETRY_STREAM_OPERATOR_SINK
("HOSTNAME" VARCHAR(128)
,"MEASURED_AT" TIMESTAMP
,"NODE_ID" VARCHAR(8)
,"GRAPH_ID" INTEGER
,"SOURCE_SQL" VARCHAR(1024)
,"QUERY_PLAN" VARCHAR(1024)
,"NAME_IN_QUERY_PLAN" VARCHAR(64)
,"NUM_INPUTS" INTEGER
,"INPUT_NODES" VARCHAR(64)
,"NUM_OUTPUTS" INTEGER
,"OUTPUT_NODES" VARCHAR(64)
,"SCHED_STATE" CHAR(2)
,"LAST_EXEC_RESULT" CHAR(3)
,"NUM_BUSY_NEIGHBORS" INTEGER
,"INPUT_ROWTIME_CLOCK" TIMESTAMP
,"OUTPUT_ROWTIME_CLOCK" TIMESTAMP
,"EXECUTION_COUNT" BIGINT
,"STARTED_AT" TIMESTAMP
,"LATEST_AT" TIMESTAMP
,"NET_EXECUTION_TIME" DOUBLE
,"NET_SCHEDULE_TIME" DOUBLE
,"NET_INPUT_BYTES" BIGINT
,"NET_INPUT_ROWS" BIGINT
,"NET_INPUT_RATE" DOUBLE
,"NET_INPUT_ROW_RATE" DOUBLE
,"NET_OUTPUT_BYTES" BIGINT
,"NET_OUTPUT_ROWS" BIGINT
,"NET_OUTPUT_RATE" DOUBLE
,"NET_OUTPUT_ROW_RATE" DOUBLE
,"NET_MEMORY_BYTES" BIGINT
,"MAX_MEMORY_BYTES" BIGINT
)
OPTIONS (
    "FORMATTER" 'ORC',
    "orc.version" 'V_0_11',
    "FILENAME_SUFFIX" '.orc',
    "FILENAME_DATE_FORMAT" 'yyyy-MM-dd-HH.mm.ss',
    "FILE_ROTATION_TIME" '%FILE_ROTATION_TIME%',   
    "FORMATTER_INCLUDE_ROWTIME" 'false',
    "FILE_ROTATION_RESPECT_ROWTIME" 'true'

    -- these are the table-specific options

    "DIRECTORY" '/home/sqlstream/telemetry/streamop',
    "FILENAME_PREFIX" 'streamop-out-%HOSTNAME%',
    "ORIGINAL_FILENAME" 'pending-streamop.orc',

    "HDFS_OUTPUT_DIR" '/data/svc_sqlstream_guavus/telemetry/streamop', 

    "HIVE_SCHEMA_NAME" 'salstream_telemetry',
    "HIVE_TABLE_NAME" 'telemetry_stream_operator_info',

    -- these are HDFS / Hive server options

    "HIVE_URI" 'jdbc:hive2://sqlstream01-slv-01.cloud.in.guavus.com:2181,sqlstream01-slv-02.cloud.in.guavus.com:2181,sqlstream01-slv-03.cloud.in.guavus.com:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2-hive2',
    "HIVE_METASTORE_URIS" 'thrift://sqlstream01-mst-01.cloud.in.guavus.com:9083,thrift://sqlstream01-mst-02.cloud.in.guavus.com:9083',
    "CONFIG_PATH" '/home/sqlstream/core-site.xml:/home/sqlstream/hdfs-site.xml',
    "AUTH_METHOD" 'kerberos',
    "AUTH_USERNAME" 'svc_sqlstream_guavus@GVS.GGN',
    "AUTH_KEYTAB" '/home/sqlstream/svc_sqlstream_guavus.keytab',
    "AUTH_METASTORE_PRINCIPAL" 'hive/_HOST@GVS.GGN',
    );

