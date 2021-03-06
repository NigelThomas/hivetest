#!/bin/bash
#
# Do any preproject setup needed before loading the StreamLab projects
#
# Assume we are running in the project directory
. /etc/sqlstream/environment

# dereference any environment vars passed in by SQLSTREAM_APPLICATION_OPTIONS

for opt in $SQLSTREAM_APPLICATION_OPTIONS
do
    echo setting $opt
    export $opt
done

mkdir -p $SQLSTREAM_HOME/classes/net/sf/farrago/dynamic/

echo ... preparing the application schema  
# update setup.sql to replace placeholders with actual values
echo ... running on host=`hostname`
cat ${EXPERIMENT_NAME}/setup.sql | sed -e "s/%HOSTNAME%/`hostname`/g" -e "s/%FILE_ROTATION_TIME%/${FILE_ROTATION_TIME:=1m}/" >/tmp/setup.sql


echo ... preparing the telemetry and trace schemas
# make the needed subs

cat > /tmp/trace.sed <<!END
s/%HOSTNAME%/$(hostname)/g
s/%FILE_ROTATION_TIME%/15m/g
s/%TELEMETRY_PERIOD_SECS%/30/g
!END

# append the monitoring to the setup script

for f in trace/trace_hive_sinks.sql trace/trace_pumps.sql \
         telemetry/telemetry_hive_sinks.sql telemetry/telemetry_pumps.sql
do
    b=$(basename $f)
    echo ... ... $b
    cat $f | sed -f /tmp/trace.sed >> /tmp/setup.sql
    # rm /tmp/$b
done

echo ... installing the application, trace and telemetry schemas

$SQLSTREAM_HOME/bin/sqllineClient --color=auto --run=/tmp/setup.sql






