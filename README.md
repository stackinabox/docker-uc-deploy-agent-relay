# docker-urbancode-deploy-agent
Containerised UrbanCode Deploy Agent

#### **Build Image:**<br />

`git clone https://github.com/stackinabox/docker-uc-deploy-agent.git`

`curl -u%username%:%password% -O http://artifactory.stackinabox.io/artifactory/urbancode-snapshot-local/urbancode/ibm-ucd-agent/%UCD_AGENT_VERSION%/ibm-ucd-agent.zip`
	
`unzip -q ibm-ucd-agent.zip -d artifacts/`
`rm -f ibm-ucd-agent.zip`
`docker build -t stackinabox/urbancode-deploy-agent:%UCD_AGENT_VERSION% .`

#### **Run Image:**<br />
`docker run -d -e "UCD_SERVER=192.168.27.100" --name localagent stackinabox/urbancode-deploy-agent`<br />

Environment variables:
UCD_SERVER - IP/hostname of UCD server agent should connect to default port 7918 assumed
AGENT_NAME - name to use for agent; defaults to localagent

