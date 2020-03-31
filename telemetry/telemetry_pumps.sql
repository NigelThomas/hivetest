-- targets/telemetry/deliver.sql
--
-- Deliver data from source (a telemetry view) to target (a Hive or Kafka sink, depending on configuration)
-- 
-- Substitution parameters:
--   %HOSTNAME%
--   %TELEMETRY_PERIOD_SECS%

SET SCHEMA '"SQLstream_Telemetry"';

CREATE OR REPLACE PUMP TELEMETRY_SERVER_PUMP STOPPED
AS
INSERT INTO TELEMETRY_SERVER_SINK
SELECT STREAM '%HOSTNAME%',* from STREAM(sys_boot.mgmt.getServerInfoForever(%TELEMETRY_PERIOD_SECS%))
;


CREATE OR REPLACE PUMP TELEMETRY_STREAM_GRAPH_PUMP STOPPED
AS
INSERT INTO TELEMETRY_STREAM_GRAPH_SINK
SELECT STREAM '%HOSTNAME%',* from STREAM(sys_boot.mgmt.getStreamGraphInfoForever(0, %TELEMETRY_PERIOD_SECS%))
;


CREATE OR REPLACE PUMP TELEMETRY_STREAM_OPERATOR_PUMP STOPPED
AS
INSERT INTO TELEMETRY_STREAM_OPERATOR_SINK
SELECT STREAM '%HOSTNAME%',* from STREAM(sys_boot.mgmt.getStreamOperatorInfoForever(0, %TELEMETRY_PERIOD_SECS%))
;


