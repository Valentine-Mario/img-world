Rails.application.routes.draw do
  scope 'user' do
    post '/add', :to=>"user#createUser"
    get '/makeadmin/:id', :to=>"user#setAdmin"
    post '/login', :to=>"auth#login"
    post '/adminlogin', :to=>"auth#adminLogin"
  end
end
