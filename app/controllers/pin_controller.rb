class PinController < ApplicationController
    before_action :authorize_request
    before_action :set_pin_user, only:[:removePin]
    include Rails.application.routes.url_helpers
    respond_to :html, :json
    def addPin 
        @user_pin=@current_user.pins
        for i in @user_pin do     
            if i.gallery_id.equal?(params[:gallery_id].to_i)
                found=true
                break;  
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

    def getPins
        @user_pin=@current_user.pins.paginate(page: params[:page], per_page: params[:per_page])
        respond_to do |format|
            format.json{ render :json=>@user_pin.to_json(:include=> :gallery)}
        end
        
    end

    def removePin
        @pin.destroy
        render :json=>{code:"00", message:"item unpinned successfully"}
    end

    private
    def set_pin_user
        @pin = @current_user.pins.find_by!(id: params[:id]) if @current_user
      end
    
end
