class HomeController < Wrails::Controller
  def index
    # @messages = Message.all
  end

  def create
    Message.create(text: request.params[:text])
    # redirect '/'
  end
end
