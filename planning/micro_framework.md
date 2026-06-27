What needs to be done to use this app as a microframework?

Macros:
  - should include all essential features (✅ done partially, list below of missing features)
  - should be packaged as a gem (✅ done and tested)
  - global refactoring after features done (✅ done)
  - read actual microframework source code (e.g. Sinatra): compare, reflect, etc
  - start thinking about transition into full framework (Rails like) (✅ done, in a separate file)


Missing features:
  - before filters/hooks
  - error handlers
  - cookies
  - sessions
  - middlewares
(probably gonna skip them for now and implement with full framework functionality)


======================================================================
Essential features (pseudocode):

app = new MicroFramework()

// Middleware (runs before every request)
app.before(request):
    log(request.method + " " + request.path)
    if not request.headers["Authorization"]:
        return response(401, {error: "Unauthorized"})

// Middleware (runs after every request)
app.after(response):
    response.headers["X-Server"] = "MicroFramework"
    return response

// Route with parameter and query handling
app.get("/users/:id", function(request):
    id = request.params.id
    page = request.query.page or 1
    limit = request.query.limit or 10

    user = db.find(id)
    if not user:
        return response(404, {error: "User not found"})

    // Using template
    html = render_template("user_profile.html", {
        name: user.name,
        email: user.email,
        page: page,
        limit: limit
    })

    return response(200, html, content_type="text/html")
)

// Another route returning JSON
app.post("/users", function(request):
    data = request.body
    if not data.name or not data.email:
        return response(400, {error: "Missing fields"})

    new_user = db.create(data)
    return response(201, new_user, content_type="application/json")
)

// Start server
app.listen(port=3000)
