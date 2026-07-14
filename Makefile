test:
	ruby test/run_all.rb

# make testx TEST=test_post_request
testx:
	ruby test/wrails_test.rb -n $(TEST)

showcase:
	ruby examples/full_framework/app.rb

.PHONY: test
