Rails.application.routes.draw do
  scope 'user' do
    post '/add', :to=>"user#createUser"
  end
end
