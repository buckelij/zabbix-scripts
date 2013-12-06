#!/bin/bash
#call every 5 minutes. returns a 5-minute cpu load average.
#pass in the DBInstanceIdentifier name as the first argument
#returns 9999 if the metric cannot be retrieved.

export AWS_ACCESS_KEY_ID='REDACTED' #preferably, an account with only read-only access to cloudwatch
export AWS_SECRET_ACCESS_KEY='REDACTED'
export AWS_DEFAULT_REGION='us-east-1'

PERCENT=$(/usr/bin/aws cloudwatch get-metric-statistics \
    --namespace AWS/RDS --metric-name CPUUtilization \
    --start-time `date -d '-5 min' --iso-8601=seconds` --end-time `date --iso-8601=seconds` --period 300 \
    --statistics Average --dimensions Name=DBInstanceIdentifier,Value=$1 \
    | grep '"Average": ' | sed 's/.*"Average": //' | sed 's/,.*//')

re='^[0-9]+([.][0-9]+)?$'
if ! [[ $PERCENT =~ $re ]] ; then
  PERCENT=9999;
fi
echo $PERCENT
exit 0
