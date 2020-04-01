-- Sink foreign streams for Hive output
--
-- parameters
--  %FILE_ROTATION_TIME% -- wants to be low for latency, high for compression
--  %HOSTNAME%

CREATE OR REPLACE SCHEMA "SQLstream_Telemetry";
SET SCHEMA '"SQLstream_Telemetry"';

create or replace FOREIGN STREAM TELEMETRY_SERVER_SINK
("hostname" varchar(128)
,"measured_at" timestamp
,"is_running" boolean
,"is_licensed" boolean
,"license_kind" varchar(32)
,"license_version" varchar(32)
,"is_throttled" boolean
,"num_sessions" integer
,"num_statements" integer
,"started_at" timestamp
,"throttled_at" timestamp
,"throttle_level" double
,"num_exec_threads" integer
,"num_stream_graphs_open" integer
,"num_stream_graphs_closed" integer
,"num_stream_operators" integer
,"num_stream_graphs_open_ever" integer
,"num_stream_graphs_closed_ever" integer
,"net_memory_bytes" bigint
,"max_memory_bytes" bigint
,"usage_at" timestamp
,"usage_since" timestamp
,"usage_reported_at" timestamp
,"net_input_bytes" bigint
,"net_output_bytes" bigint
,"net_input_bytes_today" bigint
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
    "AUTH_METASTORE_PRINCIPAL" 'hive/_HOST@GVS.GGN'
    );


create or replace FOREIGN STREAM TELEMETRY_STREAM_GRAPH_SINK
("hostname" varchar(128)
,"measured_at" timestamp
,"graph_id" integer
,"statement_id" integer
,"session_id" integer
,"source_sql" varchar(2048)
,"sched_state" char(1)
,"close_mode" char(6)
,"is_global_nexus" boolean
,"is_auto_close" boolean
,"num_nodes" integer
,"num_live_nodes" integer
,"num_data_buffers" integer
,"total_execution_time" double
,"total_opening_time" double
,"total_closing_time" double
,"net_input_bytes" bigint
,"net_input_rows" bigint
,"net_input_rate" double
,"net_input_row_rate" double
,"net_output_bytes" bigint
,"net_output_rows" bigint
,"net_output_rate" double
,"net_output_row_rate" double
,"net_memory_bytes" bigint
,"max_memory_bytes" bigint
,"when_opened" timestamp
,"when_started" timestamp
,"when_finished" timestamp
,"when_closed" timestamp
)
OPTIONS (
    "FORMATTER" 'CSV',
    "orc.version" 'V_0_11',
    "FILENAME_SUFFIX" '.orc',
    "FILENAME_DATE_FORMAT" 'yyyy-MM-dd-HH.mm.ss',
    "FILE_ROTATION_TIME" '%FILE_ROTATION_TIME%',   
    "FORMATTER_INCLUDE_ROWTIME" 'false',
    "FILE_ROTATION_RESPECT_ROWTIME" 'true',

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
    "AUTH_METASTORE_PRINCIPAL" 'hive/_HOST@GVS.GGN'
    );



CREATE OR REPLACE FOREIGN STREAM TELEMETRY_STREAM_OPERATOR_SINK
("hostname" varchar(128)
,"measured_at" timestamp
,"node_id" varchar(8)
,"graph_id" integer
,"source_sql" varchar(1024)
,"query_plan" varchar(1024)
,"name_in_query_plan" varchar(64)
,"num_inputs" integer
,"input_nodes" varchar(64)
,"num_outputs" integer
,"output_nodes" varchar(64)
,"sched_state" char(2)
,"last_exec_result" char(3)
,"num_busy_neighbors" integer
,"input_rowtime_clock" timestamp
,"output_rowtime_clock" timestamp
,"execution_count" bigint
,"started_at" timestamp
,"latest_at" timestamp
,"net_execution_time" double
,"net_schedule_time" double
,"net_input_bytes" bigint
,"net_input_rows" bigint
,"net_input_rate" double
,"net_input_row_rate" double
,"net_output_bytes" bigint
,"net_output_rows" bigint
,"net_output_rate" double
,"net_output_row_rate" double
,"net_memory_bytes" bigint
,"max_memory_bytes" bigint
)
OPTIONS (
    "FORMATTER" 'ORC',
    "orc.version" 'V_0_11',
    "FILENAME_SUFFIX" '.orc',
    "FILENAME_DATE_FORMAT" 'yyyy-MM-dd-HH.mm.ss',
    "FILE_ROTATION_TIME" '%FILE_ROTATION_TIME%',   
    "FORMATTER_INCLUDE_ROWTIME" 'false',
    "FILE_ROTATION_RESPECT_ROWTIME" 'true',

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
    "AUTH_METASTORE_PRINCIPAL" 'hive/_HOST@GVS.GGN'
    );

