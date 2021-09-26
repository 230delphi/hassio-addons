#!/usr/bin/with-contenv bashio
bashio::log.error "Starting run.sh..."
git clone https://github.com/230delphi/alphaess-to-mqtt/

bashio::log.error "Building project..."
cd alphaess-to-mqtt
go build *.go

bashio::log.error "Creating Config..."
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
alphaESS-proxy -config ${CONFIG} < /dev/null