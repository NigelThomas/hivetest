-- sinks/telemetry/hive/telemetry_hive.sql
--
-- script to set up the Hive tables into which telemetry data will be stored
-- 
-- NOTE: LOCATION for these tables must match HDFS_OUTPUT_DIR for SQLstream sink foreign streams

!set force on
CREATE SCHEMA sqlstream_telemetry;
!set force off


USE sqlstream_telemetry;

!set force on
-- the alter table makes us drop any data as well as the external table
ALTER TABLE telemetry_server_info SET TBLPROPERTIES('EXTERNAL'='False');
DROP TABLE telemetry_server_info;

ALTER TABLE telemetry_stream_graph_info SET TBLPROPERTIES('EXTERNAL'='False');
DROP TABLE telemetry_stream_graph_info;

ALTER TABLE telemetry_stream_operator_info SET TBLPROPERTIES('EXTERNAL'='False');
DROP TABLE telemetry_stream_operator_info;

!set force off


-- now create the telemetry TABLES

create external table telemetry_server_info
(hostname varchar(128)
,measured_at timestamp
,is_running boolean
,is_licensed boolean
,license_kind varchar(32)
,license_version varchar(32)
,is_throttled boolean
,num_sessions int
,num_statements int
,started_at timestamp
,throttled_at timestamp
,throttle_level double
,num_exec_threads int
,num_stream_graphs_open int
,num_stream_graphs_closed int
,num_stream_operators int
,num_stream_graphs_open_ever int
,num_stream_graphs_closed_ever int
,net_memory_bytes bigint
,max_memory_bytes bigint
,usage_at timestamp
,usage_since timestamp
,usage_reported_at timestamp
,net_input_bytes bigint
,net_output_bytes bigint
,net_input_bytes_today bigint
)
STORED AS ORC
LOCATION '/data/svc_sqlstream_guavus/telemetry/server'
TBLPROPERTIES
( "orc.compress" = "SNAPPY"
);



create external table telemetry_stream_graph_info
(hostname varchar(128)
,measured_at timestamp
,graph_id int
,statement_id int
,session_id int
,source_sql varchar(2048)
,sched_state char(1)
,close_mode char(6)
,is_global_nexus boolean
,is_auto_close boolean
,num_nodes int
,num_live_nodes int
,num_data_buffers int
,total_execution_time double
,total_opening_time double
,total_closing_time double
,net_input_bytes bigint
,net_input_rows bigint
,net_input_rate double
,net_input_row_rate double
,net_output_bytes bigint
,net_output_rows bigint
,net_output_rate double
,net_output_row_rate double
,net_memory_bytes bigint
,max_memory_bytes bigint
,when_opened timestamp
,when_started timestamp
,when_finished timestamp
,when_closed timestamp
)
STORED AS ORC
LOCATION '/data/svc_sqlstream_guavus/telemetry/streamgraph'
TBLPROPERTIES
( "orc.compress" = "SNAPPY"
);

create external table telemetry_stream_operator_info
(hostname varchar(128)
,measured_at timestamp
,node_id varchar(8)
,graph_id int
,source_sql varchar(1024)
,query_plan varchar(1024)
,name_in_query_plan varchar(64)
,num_inputs int
,input_nodes varchar(64)
,num_outputs int
,output_nodes varchar(64)
,sched_state char(2)
,last_exec_result char(3)
,num_busy_neighbors int
,input_rowtime_clock timestamp
,output_rowtime_clock timestamp
,execution_count bigint
,started_at timestamp
,latest_at timestamp
,net_execution_time double
,net_schedule_time double
,net_input_bytes bigint
,net_input_rows bigint
,net_input_rate double
,net_input_row_rate double
,net_output_bytes bigint
,net_output_rows bigint
,net_output_rate double
,net_output_row_rate double
,net_memory_bytes bigint
,max_memory_bytes bigint
)
STORED AS ORC
LOCATION '/data/svc_sqlstream_guavus/telemetry/streamop'
TBLPROPERTIES
( "orc.compress" = "SNAPPY"
);


