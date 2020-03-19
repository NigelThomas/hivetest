-- Table to be created in Hive for performance test

!set force on
CREATE SCHEMA hiveperf;
!set force off


USE hiveperf;

!set force on
DROP TABLE hive_edr_hiveperf;
!set force off



CREATE TABLE hive_edr_hiveperf
(
    sn_end_time VARCHAR(32),
    sn_start_time VARCHAR(32),
    bearer_3gpp_imei VARCHAR(32),
    bearer_3gpp_imsi BIGINT,
    bearer_3gpp_rat_type INT,
    bearer_3gpp_user_location_information VARCHAR(32),
    ip_server_ip_address VARCHAR(16),
    ip_subscriber_ip_address VARCHAR(64),
    p2p_tls_sni VARCHAR(128),
    radius_calling_station_id BIGINT,
    sn_direction VARCHAR(16),
    sn_duration INT,
    sn_flow_end_time VARCHAR(32),
    sn_flow_id VARCHAR(32),
    sn_flow_start_time VARCHAR(32),
    sn_server_port INT,
    sn_subscriber_port INT,
    sn_volume_amt_ip_bytes_downlink INT,
    sn_volume_amt_ip_bytes_uplink INT,
    sn_closure_reason INT,
    event_label VARCHAR(16)
)
STORED AS ORC
LOCATION '/data/svc_sqlstream_guavus/hiveperf_edr'
TBLPROPERTIES
( "orc.compress" = "SNAPPY"
);

