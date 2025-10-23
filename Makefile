.PHONY: generate
generate:
	helm schema --values charts/wallet-gateway/values.yaml -o charts/wallet-gateway/values.schema.json --no-additional-properties

.PHONY: package
package:
	helm package charts/wallet-gateway --version $(file < VERSION) --destination target

.PHONY: test
test:
	helm unittest --color charts/wallet-gateway

.PHONY: watch
watch:
	watch -td --color '$(MAKE) generate && $(MAKE) test'
