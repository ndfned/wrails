Wrails.app.router.draw do
  get '/', to: 'home#index'
  post '/', to: 'home#create'
end
