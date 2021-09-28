# *AlphaESS* Proxy Add-on
## Installation

Follow these steps to get the add-on installed on your system:

1. Navigate in your Home Assistant frontend to:
   * **Supervisor** -> **Add-on Store** -> **Repositories** (from : top right of screen).
2. Add the Repository: *https://github.com/230delphi/hassio-addons*
3. After the Screen updates, choose ***AlphaESS Proxy*** 
4. Click ***INSTALL***.

## Modes of Operation

There are 2 modes of operation:
### 1. Transparent proxy
In this case, the main network gateway is configured to forward requests to the proxy. Depending on your skills and network configuration this may be the easiest option.
If your AlphaESS system password is unknown, this may be the only option.

Depending on your router configuration, a simple ip tables rule like below will route traffic to your new Proxy server. (replace <HA_IP> with your HA ip address)

```code
sudo iptables -t nat -D PREROUTING -p tcp --dport 7777 -j DNAT --to <HA_IP>:27777
```

Alternatively, if you have the AlphaESS password, you can configure a static IP & alternate gateway on the system and control via a dedicated gateway (I use my HA server for this purpose).  

### 2. Direct proxy
In this case, you must change the AlphaESS network configuration so that it sends data to the proxy instead of the cloud server. The Proxy is subsequently configured to forward the data to the clound.

***TODO notes on system menu***

## Add-On Configuration
### Transparent Proxy *(TP)*
1. Configure ***MQTT*** *Address / User / Password* per your configuration.
2. ***MQTTTopicBase*** - is the default - only change inline with changes to Home Assistant
3. ***AlphaESSID*** - identifies the instance - allowing for multiple deployments (albeit on different HA instances)
4. ***TZLocation*** - currently required to set timezone to times captured from the system.
5. ***ProxyIPPort*** - defines the listening interface/port.

### 2. Direct Proxy *(DP)*

***TODO***

###Example configuration

#### Transparent Proxy

```yaml
MQTTAddress: tcp://127.0.0.1:1883
MQTTUser: user
MQTTPassword: password
MQTTTopicBase: homeassistant/sensor/
AlphaESSID: alphaess1
TZLocation: Europe/Dublin
ProxyIPPort: 0.0.0.0:27777
MSGLogging: GenericRQ,CommandIndexRQ,CommandRQ,ConfigRS,StatusRQ
```

MSGLogging allows for the logging of specific Message types (GenericRQ,CommandIndexRQ,CommandRQ,ConfigRS,StatusRQ)