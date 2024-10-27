.ONESHELL:
SHELL := /bin/bash

all:

shelly-light.yaml: shelly-light.yaml.in
	@
	chmod +w $@
	if [ -z "$(SHELLY_LIGHT_WLAN_SSID)" ]; then echo "SHELLY_LIGHT_WLAN_SSID is not set"; exit 1; fi
	if [ -z "$(SHELLY_LIGHT_WLAN_PW)" ]; then echo "SHELLY_LIGHT_WLAN_PW is not set"; exit 1; fi
	sed \
		-e 's/@SHELLY_LIGHT_WLAN_SSID@/$(SHELLY_LIGHT_WLAN_SSID)/' \
		-e 's/@SHELLY_LIGHT_WLAN_PW@/$(SHELLY_LIGHT_WLAN_PW)/' \
		$< > $@
	chmod a-w $@

upload: shelly-light.yaml
	@echo "Uploading shelly-light pod"
	@artemis pod upload shelly-light.yaml
