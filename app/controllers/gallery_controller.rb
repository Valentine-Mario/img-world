class GalleryController < ApplicationController
    include Rails.application.routes.url_helpers
    before_action :authorize_request, except:[:getAllPost, :getPostId]
    before_action :findPost, only:[:getPostId, :editPost]
    before_action :set_post_user, only:[:editPost]
    respond_to :html, :json
    def createPost
        
        @post = @current_user.galleries.create!(post_params)
        respond_to do |format|
        if @post.save
            format.json { render(json: {code:"00", message: @post} ) }
            #render :json=>{code:"00", message:@post}  
        else
            format.json { render(json: {code:"01", message:@post.errors} ) }
            #render :json=>{code:"01", message:@post.errors}
        end
    end
    end

    def getAllPost
        @gallery= Gallery.all
        arr=[]
        for i in @gallery do
            #pics = rails_blob_url(i.pics)
            pics= i.pics.map{|img| ({ image: url_for(img) })}
            arr.push({pics:pics, content:i})   
        end
         render :json=>{code:"00", message:arr}
    end

    def getPostId
        # pics= rails_blob_url(@post_id.pics)
        # render :json=>{code:"00", message:@post_id, image:pics}
       image= @post_id.pics.map{|img| ({ image: url_for(img) })}
       render :json=>{code:"00", message:@post_id, pics:image}
    end

    def getPostForUser
        @user_post=@current_user.galleries
        arr=[]
        for i in @user_post do
            #pics = rails_blob_url(i.pics)
            pics= i.pics.map{|img| ({ image: url_for(img) })}
            arr.push({pics:pics, content:i})   
        end
        render :json=>{code:"00", message:arr}
    end

    def editPost
        if @post.update(editParams)
            render :json=>{code:"00", message:"update successful"}
        else
            render :json=>{code:"01", message:"error updating title"}
        end
    end

    private

    def findPost
        @post_id = Gallery.find(params[:id])
    end
    
    def post_params
        params.permit(:title, pics:[])
    end

    def editParams
        params.permit(:title)
    end

    def set_post_user
        @post = @current_user.galleries.find_by!(id: params[:id]) if @current_user
      end
end
