MOCHA_OPTS=
REPORTER = spec 

check: test

test: test-unit

test-unit:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--reporter $(REPORTER) \
		$(MOCHA_OPTS)

# test-acceptance:
# 	@NODE_ENV=test ./node_modules/.bin/mocha \
# 		--reporter $(REPORTER) \
# 		--bail \
# 		test/acceptance/*.js

.PHONY: test
