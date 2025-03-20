.ONESHELL:
SHELL := /bin/bash

.PHONY: all
all:

%.yaml: %.yaml.in
	@
	chmod +w $@
	if [ -z "$(WLAN_SSID)" ]; then echo "WLAN_SSID is not set"; exit 1; fi
	if [ -z "$(WLAN_PW)" ]; then echo "WLAN_PW is not set"; exit 1; fi
	sed \
		-e 's/@WLAN_SSID@/$(WLAN_SSID)/' \
		-e 's/@WLAN_PW@/$(WLAN_PW)/' \
		$< > $@
	chmod a-w $@

.PHONY: upload
upload: upload-shelly upload-hp-plug

.PHONY: upload-hp-plug
upload-hp-plug: home-base.yaml
	@echo "Uploading hp-plug pod"
	@artemis pod upload hp-plug.yaml

.PHONY: upload-shelly
upload-shelly: upload-shelly-kitchen upload-shelly-living

.PHONY: upload-shelly-kitchen
upload-shelly-kitchen: home-base.yaml
	@echo "Uploading shelly-light pod"
	@artemis pod upload shelly-light-kitchen.yaml

.PHONY: upload-shelly-living
upload-shelly-living: home-base.yaml
	@echo "Uploading shelly-light pod"
	@artemis pod upload shelly-light-living.yaml
