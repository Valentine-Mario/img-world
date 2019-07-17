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
    get '/getuser', :to=>"gallery#getPostForUser"
    post '/edit/:id', :to=>"gallery#editPost"
    post '/addpics/:id', :to=>"gallery#addExtraPhoto"
    get '/deletepics/:id', :to=>"gallery#deletePhoto"
    get '/delete/:id', :to=>"gallery#deletePost"
  end

  #comment routes
  scope 'comment' do
    post '/add/:gallery_id', :to=>"comment#addComment"
    get '/get/:id', :to=>"comment#getAllCommentForGallery"
    post '/edit/:id', :to=>"comment#editComment"
  end
end
