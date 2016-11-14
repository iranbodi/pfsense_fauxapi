#!/bin/bash
# 
# Copyright 2016 Nicholas de Jong  <contact[at]nicholasdejong.com>
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 

# include source library
source $(dirname ${0})/bash/fauxapi_lib.sh

# config
fauxapi_host='<pfsense-host>'
fauxapi_apikey='<apikey>'
fauxapi_apisecret='<apisecret>'

# establish the debug and auth then export
export fauxapi_debug=false
export fauxapi_auth=`fauxapi_auth ${fauxapi_apikey} ${fauxapi_apisecret}`


# get config request
# NB: must have the 'jq' binary to process the JSON response easily!
fauxapi_config_get ${fauxapi_host} | jq .data.config > /tmp/pfsense-fauxapi.json

# set a config
fauxapi_config_set ${fauxapi_host} /tmp/pfsense-fauxapi.json

# reload the current config
fauxapi_config_reload ${fauxapi_host}

# do a remote config backup
fauxapi_config_backup ${fauxapi_host}

# get the list of backup files
fauxapi_config_backup_list ${fauxapi_host}

# restore a previous config
#fauxapi_config_restore ${fauxapi_host} /cf/conf/backup/config-1478948093.xml

# do a pfsense send_event($command) call
fauxapi_send_event ${fauxapi_host} 'filter reload'

# reboot the system
# fauxapi_system_reboot ${fauxapi_host}

