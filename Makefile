test:
	ruby test/wrails_test2.rb

# make testx TEST=test_post_request
testx:
	ruby test/wrails_test.rb -n $(TEST)

example:
	ruby examples/full_framework/app.rb

.PHONY: test
