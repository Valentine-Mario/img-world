class UserController < ApplicationController
    before_action :authorize_request, except: [:createUser, :getAllUsers, :getUserById]
    before_action :findUser, only:[:setAdmin]
    def createUser
        @new_user=User.new(user_params)
        if @new_user.save
            token = JsonWebToken.encode(user_id: @new_user.id)
            render :json=>{code:"00", message:"user created successfully", token:token}
        else
            render :json=>{code:"01", message:@new_user.errors}
        end
    end

    def setAdmin
        if @user.isAdmin == true
         render :json=>{code:"01", message:@user.name+ " is already an admin"}
        elsif @user.update(makeAdmin)
            render :json=>{code:"00", message:@user.name+ " is now an admin"}
        else
            render :json=>{code:"01", message:"error making "+ @user.name+ " an admin"}
        end 
    end


    private

    def findUser
        @user = User.find(params[:id])
      end
    def user_params
        
        params.permit(
           :name, :email, :password, :password_confirmation, :isAdmin
          )
    end

    def makeAdmin
        defaults = { isAdmin: true }
        params.permit(:isAdmin).reverse_merge(defaults)
    end
end
