CREATE OR REPLACE SCHEMA "hiveperf";
SET SCHEMA '"hiveperf"';


CREATE OR REPLACE FOREIGN STREAM "edr_data_fs"
(
    "sn-end-time" VARCHAR(32),
    "sn-start-time" VARCHAR(32),
    "bearer-3gpp imei" VARCHAR(32),
    "bearer-3gpp imsi" BIGINT,
    "bearer-3gpp rat-type" INTEGER,
    "bearer-3gpp user-location-information" VARCHAR(32),
    "ip-server-ip-address" VARCHAR(16),
    "ip-subscriber-ip-address" VARCHAR(64),
    "p2p-tls-sni" VARCHAR(128),
    "radius-calling-station-id" BIGINT,
    "sn-direction" VARCHAR(16),
    "sn-duration" INTEGER,
    "sn-flow-end-time" VARCHAR(32),
    "sn-flow-id" VARCHAR(32),
    "sn-flow-start-time" VARCHAR(32),
    "sn-server-port" INTEGER,
    "sn-subscriber-port" INTEGER,
    "sn-volume-amt-ip-bytes-downlink" INTEGER,
    "sn-volume-amt-ip-bytes-uplink" INTEGER,
    "sn-closure-reason" INTEGER,
    "event-label" VARCHAR(16)
)
    SERVER "FILE_SERVER"

OPTIONS (
"PARSER" 'CSV',
        "CHARACTER_ENCODING" 'UTF-8',
        "QUOTE_CHARACTER" '"',
        "SEPARATOR" ',',
        "SKIP_HEADER" 'false',                          -- headers stripped from files because of bug with REPEAT

        "DIRECTORY" '/home/sqlstream/hiveperf/edr',
        "FILENAME_PATTERN" '.*REPORTOCS.*',

                                                        -- the sample data set is 600k rows; this expands that to 60M rows and can be changed to 'FOREVER' if needed
	"STATIC_FILES" 'true',
	"REPEAT" '200'

);


-- CREATE OR REPLACE STREAM "edr_data"
-- (
--     "sn-end-time" VARCHAR(32),
--     "sn-start-time" VARCHAR(32),
--     "bearer-3gpp imei" VARCHAR(32),
--     "bearer-3gpp imsi" BIGINT,
--     "bearer-3gpp rat-type" INTEGER,
--     "bearer-3gpp user-location-information" VARCHAR(32),
--     "ip-server-ip-address" VARCHAR(16),
--     "ip-subscriber-ip-address" VARCHAR(64),
--     "p2p-tls-sni" VARCHAR(128),
--     "radius-calling-station-id" BIGINT,
--     "sn-direction" VARCHAR(16),
--     "sn-duration" INTEGER,
--     "sn-flow-end-time" VARCHAR(32),
--     "sn-flow-id" VARCHAR(32),
--     "sn-flow-start-time" VARCHAR(32),
--     "sn-server-port" INTEGER,
--     "sn-subscriber-port" INTEGER,
--     "sn-volume-amt-ip-bytes-downlink" INTEGER,
--     "sn-volume-amt-ip-bytes-uplink" INTEGER,
--     "sn-closure-reason" INTEGER,
--     "event-label" VARCHAR(16)
-- );

-- CREATE OR REPLACE PUMP "input_pump" STOPPED
-- AS
-- INSERT INTO "edr_data"
-- (
--     "sn-end-time",
--     "sn-start-time",
--     "bearer-3gpp imei",
--     "bearer-3gpp imsi",
--     "bearer-3gpp rat-type",
--     "bearer-3gpp user-location-information",
--     "ip-server-ip-address",
--     "ip-subscriber-ip-address",
--     "p2p-tls-sni",
--     "radius-calling-station-id",
--     "sn-direction",
--     "sn-duration",
--     "sn-flow-end-time",
--     "sn-flow-id",
--     "sn-flow-start-time",
--     "sn-server-port",
--     "sn-subscriber-port",
--     "sn-volume-amt-ip-bytes-downlink",
--     "sn-volume-amt-ip-bytes-uplink",
--     "sn-closure-reason",
--     "event-label"
-- )
-- SELECT STREAM 
--     "sn-end-time",
--     "sn-start-time",
--     "bearer-3gpp imei",
--     "bearer-3gpp imsi",
--     "bearer-3gpp rat-type",
--     "bearer-3gpp user-location-information",
--     "ip-server-ip-address",
--     "ip-subscriber-ip-address",
--     "p2p-tls-sni",
--     "radius-calling-station-id",
--     "sn-direction",
--     "sn-duration",
--     "sn-flow-end-time",
--     "sn-flow-id",
--     "sn-flow-start-time",
--     "sn-server-port",
--     "sn-subscriber-port",
--     "sn-volume-amt-ip-bytes-downlink",
--     "sn-volume-amt-ip-bytes-uplink",
--     "sn-closure-reason",
--     "event-label"
-- FROM "edr_data_fs";


-- Note columns are lower-cased and hyphens and spaces turned to underscores
-- FILE_ROTATION_ROWCOUNT used to force file output

CREATE OR REPLACE FOREIGN STREAM "hive_edr_data"
(
    "sn_end_time" VARCHAR(32),
    "sn_start_time" VARCHAR(32),
    "bearer_3gpp_imei" VARCHAR(32),
    "bearer_3gpp_imsi" BIGINT,
    "bearer_3gpp_rat_type" INTEGER,
    "bearer_3gpp_user_location_information" VARCHAR(32),
    "ip_server_ip_address" VARCHAR(16),
    "ip_subscriber_ip_address" VARCHAR(64),
    "p2p_tls_sni" VARCHAR(128),
    "radius_calling_station_id" BIGINT,
    "sn_direction" VARCHAR(16),
    "sn_duration" INTEGER,
    "sn_flow_end_time" VARCHAR(32),
    "sn_flow_id" VARCHAR(32),
    "sn_flow_start_time" VARCHAR(32),
    "sn_server_port" INTEGER,
    "sn_subscriber_port" INTEGER,
    "sn_volume_amt_ip_bytes_downlink" INTEGER,
    "sn_volume_amt_ip_bytes_uplink" INTEGER,
    "sn_closure_reason" INTEGER,
    "event_label" VARCHAR(16)
)

SERVER HIVE_SERVER

OPTIONS (
    "FORMATTER" 'ORC',
        --"orc.block.padding" 'true',
        --"orc.block.size" '134217728',
        --"orc.direct.encoding.columns" '',
        --"orc.batch.size" '10000',
        "orc.version" 'V_0_11',

        "DIRECTORY" '/home/sqlstream/output',
        "FILENAME_PREFIX" 'edr-out-%HOSTNAME%',
        "FILENAME_SUFFIX" '.orc',
        "FILENAME_DATE_FORMAT" 'yyyy-MM-dd-HH.mm.ss',
        
        
        "FILE_ROTATION_TIME" '60s',   -- force frequent file rotations
        "ORIGINAL_FILENAME" 'pending-edr.orc',

        
        "HIVE_SCHEMA_NAME" 'hiveperf',
        "HIVE_TABLE_NAME" 'hive_edr_hiveperf',
        "HIVE_URI" 'jdbc:hive2://sqlstream01-slv-01.cloud.in.guavus.com:2181,sqlstream01-slv-02.cloud.in.guavus.com:2181,sqlstream01-slv-03.cloud.in.guavus.com:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2-hive2',
        "HIVE_METASTORE_URIS" 'thrift://sqlstream01-mst-01.cloud.in.guavus.com:9083,thrift://sqlstream01-mst-02.cloud.in.guavus.com:9083',
        "CONFIG_PATH" '/home/sqlstream/core-site.xml:/home/sqlstream/hdfs-site.xml',
        "AUTH_METHOD" 'kerberos',
        "AUTH_USERNAME" 'svc_sqlstream_guavus@GVS.GGN',
        "AUTH_KEYTAB" '/home/sqlstream/svc_sqlstream_guavus.keytab',
        "AUTH_METASTORE_PRINCIPAL" 'hive/_HOST@GVS.GGN',
        
        
        "FORMATTER_INCLUDE_ROWTIME" 'false',
        "FILE_ROTATION_RESPECT_ROWTIME" 'false'

    );

-- This pump deals with column renames

CREATE OR REPLACE PUMP "output_pump" STOPPED
AS
INSERT INTO "hive_edr_data"
(
    "sn_end_time",
    "sn_start_time",
    "bearer_3gpp_imei",
    "bearer_3gpp_imsi",
    "bearer_3gpp_rat_type",
    "bearer_3gpp_user_location_information",
    "ip_server_ip_address",
    "ip_subscriber_ip_address",
    "p2p_tls_sni",
    "radius_calling_station_id",
    "sn_direction",
    "sn_duration",
    "sn_flow_end_time",
    "sn_flow_id",
    "sn_flow_start_time",
    "sn_server_port",
    "sn_subscriber_port",
    "sn_volume_amt_ip_bytes_downlink",
    "sn_volume_amt_ip_bytes_uplink",
    "sn_closure_reason",
    "event_label"
)
SELECT STREAM 
    "sn-end-time",
    "sn-start-time",
    "bearer-3gpp imei",
    "bearer-3gpp imsi",
    "bearer-3gpp rat-type",
    "bearer-3gpp user-location-information",
    "ip-server-ip-address",
    "ip-subscriber-ip-address",
    "p2p-tls-sni",
    "radius-calling-station-id",
    "sn-direction",
    "sn-duration",
    "sn-flow-end-time",
    "sn-flow-id",
    "sn-flow-start-time",
    "sn-server-port",
    "sn-subscriber-port",
    "sn-volume-amt-ip-bytes-downlink",
    "sn-volume-amt-ip-bytes-uplink",
    "sn-closure-reason",
    "event-label"
FROM "edr_data_fs";

-- CREATE OR REPLACE VIEW "edr_per_min"
-- AS
-- SELECT STREAM COUNT(*) as "edr_count"
-- FROM  "edr_data" s
-- GROUP BY STEP(s.rowtime by INTERVAL '1' MINUTE)
-- ;

-- CREATE OR REPLACE FOREIGN STREAM "edr_per_min_fs"
-- ( "edr_count" BIGINT
-- )
-- SERVER FILE_SERVER
-- options
-- ( "FORMATTER" 'CSV'
-- , "DIRECTORY" '/home/sqlstream/monitor'
-- , "FILENAME_PREFIX" 'count-%HOSTNAME%'
-- , "FILENAME_SUFFIX" '.csv'
-- , "FILENAME_DATE_FORMAT" 'yyyy-MM-dd-HH.mm.ss'
-- , "FILE_ROTATION_TIME" '1d'   -- we don't really want rotation
-- , "ORIGINAL_FILENAME" 'edr_minute_count-%HOSTNAME%.csv'
-- , "FORMATTER_INCLUDE_ROWTIME" 'true'
-- );

-- CREATE OR REPLACE PUMP "edr_per_min_pump"
-- AS
-- INSERT INTO "edr_per_min_fs" ("edr_count")
-- SELECT STREAM "edr_count"
-- FROM "edr_per_min";