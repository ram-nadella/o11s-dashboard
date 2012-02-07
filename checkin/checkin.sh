#! /bin/bash
set -x
# Run this script from cron, eg.
# 1. sudo crontab -e
# 2. add a line like
# */5 * * * * /root/o11s-dash/checkin.sh
# 3. confirm that the Last Seen field for your mesh node is updated

DASHBOARD_URL='http://o11s-dashboard.appspot.com'
NETID='605_market'
MESH_IFACE=mesh0
MACADDR=`ip link show ${MESH_IFACE} | grep 'link/ether' | awk '{ print $2 }'`
PEERS=`iw $MESH_IFACE station dump | grep -e ESTAB -B 14 | grep -e Station | awk '{ print $2 }'`

for p in ${PEERS}
do
	PEER_ARGS=`echo -n $PEER_ARGS"&peer=$p"`
done
POSTDATA="netid=${NETID}&macaddr=${MACADDR}${PEER_ARGS}"

wget -O - -d --post-data ${POSTDATA} ${DASHBOARD_URL}/checkin
# OR
# curl -f -s ${DASHBOARD_URL}/checkin -d ${POSTDATA}"
# OR
# wget -O - ${DASHBOARD_URL}/checkin"?${POSTDATA}"
