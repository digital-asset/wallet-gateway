generate:
	helm schema --values charts/wallet-gateway/values.yaml -o charts/wallet-gateway/values.schema.json --no-additional-properties

package:
	helm package charts/wallet-gateway --version $(file < VERSION) --destination target

test:
	helm unittest --color charts/wallet-gateway

watch:
	watch -td --color '$(MAKE) generate && $(MAKE) test'
