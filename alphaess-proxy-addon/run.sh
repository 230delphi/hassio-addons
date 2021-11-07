#!/usr/bin/with-contenv bashio
bashio::log.info "Starting run.sh..."
MQTTAddress=$(bashio::config 'MQTTAddress')
MQTTUser=$(bashio::config 'MQTTUser')
MQTTPassword=$(bashio::config 'MQTTPassword')
BUILD_ARCH=`bashio::info.arch`

git clone https://github.com/230delphi/alphaess-to-mqtt/

bashio::log.info "Building project..."
cd alphaess-to-mqtt
if [ "${BUILD_ARCH}" = "aarch64" ]
then
  bashio::log.info "Building for GOARCH=arm64 for ${BUILD_ARCH}"
  env GOARCH=arm64 go build *.go
else
  bashio::log.info "Default build options for: ${BUILD_ARCH}"
  go build *.go
fi

bashio::log.info "Creating Config..."

#tcp://127.0.0.1:1883
AddressTest=$(echo "${MQTTAddress}"|sed "s/tcp:\/\/.*:[0-9]*$/OK/")
if [ "${AddressTest}" = "OK" ]
then
  bashio::log.warning "Using External MQTT Address: ${MQTTAddress}"
else
  bashio::log.info "No External MQTTAddress configured or not matching pattern 'tcp://127.0.0.1:1883'. Using local instance with internal user/pass."
  MQTT_PORT=$(bashio::services mqtt "port")
  MQTT_HOST=$(bashio::services mqtt "host")
  MQTTAddress="tcp://${MQTT_HOST}:${MQTT_PORT}"
  MQTTUser=$(bashio::services mqtt "username")
  MQTTPassword=$(bashio::services mqtt "password")
fi

ProxyIPPort=$(bashio::config 'ProxyIPPort')
MQTTTopicBase=$(bashio::config 'MQTTTopicBase')
AlphaESSID=$(bashio::config 'AlphaESSID')
TZLocation=$(bashio::config 'TZLocation')
LogLevel=$(bashio::config 'LogLevel')
MSGLogging=$(bashio::config 'MSGLogging')

BaseConfig="/data/base.conf"
if [ -f ${BaseConfig} ]
then
        bashio::log.info "Base config already exists: ${BaseConfig}"
else
        bashio::log.info "Creating Base config: ${BaseConfig}"
        {
            echo "#MSGLogging=GenericRQ,CommandIndexRQ,CommandRQ,ConfigRS,StatusRQ";
            echo "#proxyConnection=MQTTReadProxyConnection";
            echo "proxyConnection=MQTTInjectProxyConnection";
            echo "stat=0";
            echo "f=/data/proxy.log";
            echo "StdOutLogging=true";
        } > ${BaseConfig}
fi

CONFIG="/data/alphaESS-proxy.conf"
{
    echo "l=${ProxyIPPort}";
    echo "MQTTAddress=${MQTTAddress}";
    echo "MQTTUser=${MQTTUser}";
    echo "MQTTPassword=${MQTTPassword}";
    echo "MQTTTopicBase=${MQTTTopicBase}";
    echo "AlphaESSID=${AlphaESSID}";
    echo "TZLocation=${TZLocation}";
    echo "MSGLogging=${MSGLogging}";
    echo "v=${LogLevel}"
} > "${CONFIG}"

{
    cat ${BaseConfig}
} >> "${CONFIG}"

# Start Proxy server
bashio::log.info "Starting Proxy server..."
./alphaESS-proxy -config ${CONFIG} < /dev/null
bashio::log.info "Shutdown Proxy server."