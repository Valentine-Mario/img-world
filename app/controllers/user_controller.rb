class UserController < ApplicationController
    before_action :authorize_request, except: [:createUser, :getAllUsers, :getUserById]

    def createUser
        @new_user=User.new(user_params)
        if @new_user.save
            token = JsonWebToken.encode(user_id: @new_user.id)
            render :json=>{code:"00", message:"user created successfully", token:token}
        else
            render :json=>{code:"01", message:@new_user.errors}
        end
    end


    private
    def user_params
        
        params.permit(
           :name, :email, :password, :password_confirmation, :isAdmin
          )
    end
end
