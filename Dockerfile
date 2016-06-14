FROM stackinabox/ibm-supervisord:3.2.2

MAINTAINER Tim Pouyer <tpouyer@us.ibm.com>

# Pass in the location of the UCD agent install zip 
ARG ARTIFACT_DOWNLOAD_URL 
ARG ARTIFACT_VERSION

# Add startup.sh script and addtional supervisord config
ADD startup.sh /opt/startup.sh
ADD supervisord.conf /tmp/supervisord.conf

# Copy in installation properties
ADD install.properties /tmp/install.properties

# get UCD server to connect to and agent name
ENV UCD_SERVER=${UCD_SERVER:-$HOSTNAME} \
	UCD_SERVER_HTTP_PORT=${UCD_SERVER_HTTP_PORT:-8080} \
	UCD_SERVER_JMS_PORT=${UCD_SERVER_JMS_PORT:-7918} \
  	AGENT_RELAY_NAME=${AGENT_RELAY_NAME:-ibm-ucd-agent-relay \
  	DEPLOY_SERVER_AUTH_TOKEN=${DEPLOY_SERVER_AUTH_TOKEN:-$DEPLOY_SERVER_AUTH_TOKEN}

# Install UCD agent
RUN wget $ARTIFACT_DOWNLOAD_URL && \
	unzip -q agent-relay-$ARTIFACT_VERSION.zip -d /tmp && \
	chmod 755 /tmp/agent-relay-install/install-silent.sh && \
	cd /tmp/agent-relay-install/ && \
	$JAVA_HOME/bin/java -Dsilent=true -Duserpropfile=/tmp/install.properties -cp "install/*" org.mozilla.javascript.tools.shell.Main install/install.js && \
	cat /tmp/supervisord.conf >> /etc/supervisor/conf.d/supervisord.conf && \
	rm -rf /tmp/agent.relay.install.properties /tmp/agent-relay-install agent-relay-$ARTIFACT_VERSION.zip /tmp/supervisord.conf

ENTRYPOINT ["/opt/startup.sh"]
CMD []
