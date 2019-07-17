class PinController < ApplicationController
    before_action :authorize_request

    def addPin
        
        
        @user_pin=@current_user.pins
        for i in @user_pin do
                
            if i.gallery_id.equal?(params[:gallery_id].to_i)
                found=true
                
            else
                found=false
               
            end
        end
        if found==false||found==nil
        @gallery = Gallery.find(params[:gallery_id])
        @pin = @gallery.pins.create
        @pin.user_id = @current_user.id
        else
            return render :json=>{code:"01", message:"already pinned this item"}, status: :ok
        end
        if @pin.save && (found==false||found==nil)
            render :json=>{code:"00", message:"pinned to your profile"}, status: :ok
        else
            render :json=>{code:"01", message:"error creating pin"}, status: :unprocessable_entity
        end
    end
end
