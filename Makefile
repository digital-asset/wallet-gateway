.PHONY: generate
generate:
	config=$(mktemp)

	jq -s '.[]' ./values.schema.base.json << '$$(npx --yes @canton-network/wallet-gateway-remote@$(file < VERSION) --config-schema)'

.PHONY: package
package:
	helm package charts/wallet-gateway --version $(file < VERSION) --destination target

.PHONY: test
test:
	helm unittest --color charts/wallet-gateway

.PHONY: watch
watch:
	watch -td --color '$(MAKE) generate && $(MAKE) test'
