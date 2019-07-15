class UserController < ApplicationController
    before_action :authorize_request, except: [:createUser, :getAllUsers, :getUserById]
    before_action :findUser, only:[:setAdmin, :unsetAdmin]
    def createUser
        @new_user=User.new(user_params)
        if @new_user.save
            token = JsonWebToken.encode(user_id: @new_user.id)
            render :json=>{code:"00", message:"user created successfully", token:token}, status: :ok
        else
            render :json=>{code:"01", message:@new_user.errors}, status: :unprocessable_entity
        end
    end

    def setAdmin
        if @current_user.isAdmin == false
            render :json=>{code:"01", message:"unauthorised to make admin"}, status: :unauthorised
        elsif @user.isAdmin == true
         render :json=>{code:"01", message:@user.name+ " is already an admin"}, status: :ok
        elsif @user.update(makeAdmin)
            render :json=>{code:"00", message:@user.name+ " is now an admin"}, status: :ok
        else
            render :json=>{code:"01", message:"error making "+ @user.name+ " an admin"}, status: :unprocessable_entity
        end 
    end

    def unsetAdmin
        if @current_user.isAdmin == false
            render :json=>{code:"01", message:"unauthorised to remove admin"}, status: :unauthorised
        elsif @user.isAdmin == false
         render :json=>{code:"01", message:@user.name+ " is not an admin"}, status: :ok
        elsif @user.update(removeAdmin)
            render :json=>{code:"00", message:@user.name+ " is no longer an admin"}, status: :ok
        else
            render :json=>{code:"01", message:"error removing "+ @user.name+ " an admin"}, status: :unprocessable_entity
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

    def removeAdmin
        defaults = { isAdmin: false }
        params.permit(:isAdmin).reverse_merge(defaults)
    end
end
