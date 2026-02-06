statuses: ✅ ⌛ ❌

1. write simple ruby app ✅
usage:
- ruby app.rb /test -> <h1>Example</h1>
- ruby app.rb /unknown -> <h1>Not Found</h1>

2. write test for the usage above ✅

3. setup linter ✅

4. write micro framework functionality ✅
so it works something like this:
require 'lib'

get '/' do
  "Hello, world!"
end

get '/test' do
  "<h1>Example</h1>"
end

5. refactor app.rb ✅
- reorganize files
- make it more idiomatic (like minimal ruby lib)



============= later
- figure out rack
 - how to set it up?
 - how to integrate it with puma?

============= devops
- setup github
- setup ci (test, linter)