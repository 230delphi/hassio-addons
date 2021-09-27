#!/usr/bin/with-contenv bashio
bashio::log.info "Starting run.sh..."
git clone https://github.com/230delphi/alphaess-to-mqtt/

bashio::log.info "Building project..."
cd alphaess-to-mqtt
go build *.go

bashio::log.info "Creating Config..."
# Create main config
ProxyIPPort=$(bashio::config 'ProxyIPPort')
MQTTAddress=$(bashio::config 'MQTTAddress')
MQTTUser=$(bashio::config 'MQTTUser')
MQTTPassword=$(bashio::config 'MQTTPassword')
MQTTTopicBase=$(bashio::config 'MQTTTopicBase')
AlphaESSID=$(bashio::config 'AlphaESSID')
TZLocation=$(bashio::config 'TZLocation')

CONFIG="alphaESS-proxy.conf"
{
    echo "l=${ProxyIPPort}";
    echo "MQTTAddress=${MQTTAddress}";
    echo "MQTTUser=${MQTTUser}";
    echo "MQTTPassword=${MQTTPassword}";
    echo "MQTTTopicBase=${MQTTTopicBase}";
    echo "AlphaESSID=${AlphaESSID}";
    echo "TZLocation=${TZLocation}";
    echo "proxyConnection=MQTTReadProxyConnection";
} > "${CONFIG}"

# Start Proxy server
bashio::log.info "Starting Proxy server..."
./alphaESS-proxy -config ${CONFIG} < /dev/null
bashio::log.info "Shutdown Proxy server."