Rails.application.routes.draw do
  scope 'user' do
    post '/add', :to=>"user#createUser"
    get '/makeadmin/:id', :to=>"user#setAdmin"
  end
end
