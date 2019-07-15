class AuthController < ApplicationController
    before_action :authorize_request, except: [:login, :adminLogin]

  def login
    @user = User.find_by_email(params[:email])
    if @user == nil
        render :json=>{code:"01", message:"email dosen't exist"}, status: :unauthorized
    elsif @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      render :json=> {code:"00", token: token, message:"log in succesful" }, status: :ok
    else
      render json: { code:"01", message:"wrong password" }, status: :unauthorized
    end
  end

  def adminLogin
    @user = User.find_by_email(params[:email])
    if @user == nil
        render :json=>{code:"01", message:"email dosen't exist"}, status: :unauthorized
    elsif @user.isAdmin ==false
        render :json=>{code:"01", message:"only admin authorised"}
    elsif @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      render :json=> {code:"00", token: token, message:"log in succesful" }, status: :ok
    else
      render json: { code:"01", message:"wrong password" }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
