class UserController < ApplicationController
    before_action :authorize_request, except: [:createUser, :getAllUsers, :getUserById]
    before_action :findUser, only:[:setAdmin, :unsetAdmin, :getUserById]

    def getCurrentUser
        render :json=> {code:"00", message:@current_user}, status: :ok
    end
    def createUser
        @new_user=User.new(user_params)
        if @new_user.save
                # Sends email to user when user is created.
                UserMailer.email(@new_user).deliver
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

    def getUserById
        render :json=> {code:"00", message:@user}, status: :ok
    end

    def getAllUsers
        @users= User.all
        render :json=>{code:"00", message:@users}
    end

    def editUser
        if @current_user.update(edit_params)
            render :json=>{code:"00", message:"update successful"}, status: :ok
        else
            render :json=>{code:"01", message:@current_user.errors}
        end
    end

    def editPassword 
        if @current_user&.authenticate(params[:old_password])
            @current_user.update(user_edit_password)
                render :json=>{message:"password updated successfully"}
         else
                render :json=>{message:"authorization failed"}
        end
    end

    def deleteUser
        if @current_user.destroy
            render :json=>{message:"user deleted successfully"}, status: :ok
        else
            render :json=>{message:"error deleting user"}
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

    def edit_params
        
        params.permit(
           :name, :email
          )
    end

    def user_edit_password
        params.permit(:password)
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
