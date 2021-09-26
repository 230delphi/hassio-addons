#!/usr/bin/with-contenv bashio
git clone https://github.com/230delphi/alphaess-to-mqtt/
cd alphaess-to-mqtt
go build *.go
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