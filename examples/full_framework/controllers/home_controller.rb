class HomeController < Wrails::Controller
  def index
    response.body = 'Home Page'

    super
  end
end
