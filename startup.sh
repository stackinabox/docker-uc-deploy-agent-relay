#!/bin/bash
#update UCD agent properties
sed -i "s/localhost/$UCD_SERVER/" /opt/ibm/agentrelay/conf/agentrelay.properties
sed -i "s/8443/$UCD_SERVER_HTTP_PORT/" /opt/ibm/agentrelay/conf/agentrelay.properties 
sed -i "s/7918/$UCD_SERVER_JMS_PORT/" /opt/ibm/agentrelay/conf/agentrelay.properties 
sed -i "s/AGENT_RELAY_NAME/$AGENT_RELAY_NAME/" /opt/ibm/agentrelay/conf/agentrelay.properties 
sed -i "s/DEPLOY_SERVER_AUTH_TOKEN/$DEPLOY_SERVER_AUTH_TOKEN/" /opt/ibm/agentrelay/conf/agentrelay.properties

set -e

IFC=$(ifconfig | grep '^[a-z0-9]' | awk '{print $1}' | grep -e ns -e eth0)
IP_ADDRESS=$(ifconfig $IFC | grep 'inet addr' | awk -F : {'print $2'} | awk {'print $1'} | head -n 1)
echo "This node has an IP of " $IP_ADDRESS

if [ -z "$PUBLIC_HOSTNAME" ]; then  
  PUBLIC_HOSTNAME=agentrelay
fi

echo "$IP_ADDRESS $PUBLIC_HOSTNAME" >> /etc/hosts

if [ -z "$DEPLOY_SERVER_AUTH_TOKEN" ]; then
	DEPLOY_SERVER_AUTH_TOKEN=$(curl -k -u admin:admin \
    	-X PUT \
    	"${UCD_SERVER}:${UCD_SERVER_HTTP_PORT}/cli/teamsecurity/tokens?user=admin&expireDate=12-31-2020-12:00" | python -c \
"import json; import sys;
data=json.load(sys.stdin); print data['token']")
fi

echo "Registering UrbanCode Deploy server: "
echo "DEPLOY_SERVER_URL=${UCD_SERVER}:${UCD_SERVER_HTTP_PORT}"
echo "DEPLOY_SERVER_AUTH_TOKEN=${DEPLOY_SERVER_AUTH_TOKEN}"

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf