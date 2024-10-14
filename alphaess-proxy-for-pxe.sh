#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Original Copyright (c) 2021-2024 tteck
# Orginal Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE
# alpha script 230delphi
# to run:
# bash -c "$(wget -qLO - https://raw.githubusercontent.com/230delphi/hassio-addons/refs/heads/main/alphaess-proxy-for-pxe.sh)"

function header_info {
  clear
  cat <<"EOF"
     _                                    ____   ____  ____
    / |  __           __                / __/  / _ / / __/
   /  | / /    ____  / /___  __        / /__  / /_  / /_
  / o |/ /    /   / /  _  / /  \      / __/  /_  / /_  /
 / __ | /__  / o / / / / / / _  \    / /__  __/ / __/ /
/_/ |_|\___|/ __/_/_/ /_/ /_/  \_\  /____/ /___/ /___/ 
           / /
          /_/         
 
EOF
}
header_info
echo -e "Loading..."
APP="AlphaESS Proxy"
var_disk="4"
var_cpu="1"
var_ram="1024"
var_os="debian"
var_version="12"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
  header_info
  bash -c "$(wget -qLO - https://raw.githubusercontent.com/230delphi/hassio-addons/refs/heads/main/alphaess-proxy-addon/run.sh)"

  if [[ ! -f /lib/systemd/system/npm.service ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi
#   msg_info "Stopping Services"
#   systemctl stop openresty
#   systemctl stop npm
#   msg_ok "Stopped Services"

  msg_ok "Updated Successfully"
  exit
}

start
build_container
description

msg_info "Setting Container to Normal Resources"
pct set $CTID -cores 1
msg_ok "Set Container to Normal Resources"
msg_ok "Completed Successfully!\n"
# echo -e "${APP} should be reachable by going to the following URL.
        #  ${BL}http://${IP}:81${CL}\n"
