.PHONY: generate
generate:
	npx --yes @canton-network/wallet-gateway-remote@$(file < VERSION) --config-schema > charts/wallet-gateway/config.schema.json

	helm schema --bundle --values charts/wallet-gateway/values.yaml -o charts/wallet-gateway/values.schema.json --no-additional-properties

.PHONY: test
test:
	helm unittest --color charts/wallet-gateway

.PHONY: watch
watch:
	watch -td --color '$(MAKE) generate && $(MAKE) test'
