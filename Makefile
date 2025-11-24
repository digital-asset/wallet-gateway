.PHONY: generate
generate:
	./generate-helm-schema.sh > charts/wallet-gateway/values.schema.json

.PHONY: package
package:
	helm package charts/wallet-gateway --version $(file < VERSION) --destination target

.PHONY: test
test:
	helm unittest --color charts/wallet-gateway

.PHONY: watch
watch:
	watch -td --color '$(MAKE) generate && $(MAKE) test'
