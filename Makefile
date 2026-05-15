test:
	ruby test/wrails_test.rb

# make testx TEST=test_post_request
testx:
	ruby test/wrails_test.rb -n $(TEST)

example:
	ruby examples/basic.rb

.PHONY: test