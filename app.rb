def handle_request(request)
  if request == '/test'
    '<h1>Example</h1>'
  else
    '<h1>Not Found</h1>'
  end
end

puts handle_request(ARGV[0])

