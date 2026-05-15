statuses: ✅ ⌛ ❌


18. (rack) handle different status codes, content types, etc.

17. add params passing to templates

16. revisit tests ✅

15. routes order should matter

14. remove puma dependency

13. views/templates ✅
get '/' do
  erb :index
end 

This renders views/index.erb

12. add query support, like /path?theme=dark ✅
get '/posts' do
  # matches "GET /posts?title=foo&author=bar"
  title = params[:title]
  author = params[:author]
  # uses title and author variables; query is optional to the /posts route
end

11. add params to routes, like /path/:id ✅

10. add support for other methods ✅

9. cascading routes, default cases (like 'not found')

8. integrate with Rack ✅

7. add ability to open in browser ✅
- check sinatra usage for examples
- implement behavior so user is able to open response <h1>Hello world!</> in browser

6. routes storage ❌
- better way to store?
- thread safe?

5. refactor app.rb ✅
- reorganize files
- make it more idiomatic (like minimal ruby lib)

4. write micro framework functionality ✅
so it works something like this:
require 'lib'

get '/' do
  "Hello, world!"
end

get '/test' do
  "<h1>Example</h1>"
end

3. setup linter ✅

2. write test for the usage above ✅

1. write simple ruby app ✅
usage:
- ruby app.rb /test -> <h1>Example</h1>
- ruby app.rb /unknown -> <h1>Not Found</h1>



============= later
- routes storage
  - better way to store?
  - thread safe?

============= devops
- setup github
- setup ci (test, linter)

============= macro goals
- implement micro framework functionality (like sinatra)
- transition micro framework into fullblown framework (like rails)