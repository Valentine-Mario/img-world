Rails.application.routes.draw do

  #user routes
  scope 'user' do
    post '/add', :to=>"user#createUser"
    get '/makeadmin/:id', :to=>"user#setAdmin"
    post '/login', :to=>"auth#login"
    post '/adminlogin', :to=>"auth#adminLogin"
    get '/removeadmin/:id', :to=>"user#unsetAdmin"
    get '/get/:id', :to=>"user#getUserById"
    get '/get', :to=>"user#getAllUsers"
    post '/edit', :to=>"user#editUser"
    get '/getprofile', :to=>"user#getCurrentUser"
    post '/editpassword', :to=>"user#editPassword"
    get '/delete', :to=>"user#deleteUser"
  end

  #gallery routes
  scope 'gallery' do
    post '/add', :to=>"gallery#createPost"
    get '/get', :to=>"gallery#getAllPost"
    get '/get/:id', :to=>"gallery#getPostId"
  end
end
