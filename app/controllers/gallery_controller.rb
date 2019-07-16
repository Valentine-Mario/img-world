class GalleryController < ApplicationController
    include Rails.application.routes.url_helpers
    before_action :authorize_request, except:[:getAllPost, :getPostId]
    before_action :findPost, only:[:getPostId]
    def createPost
        @post = @current_user.galleries.create!(post_params)
        if @post.save
            render :json=>{code:"00", message:@post}
            
        else
            render :json=>{code:"01", message:@post.errors}
        end
    end

    def getAllPost
        @gallery= Gallery.all
        arr=[]
        for i in @gallery do
            pics = rails_blob_url(i.pics)
            arr.push({image:pics, content:i})
            
        end
        # pics = rails_blob_url(@gallery.pics)
         render :json=>{code:"00", message:arr}
    end

    def getPostId
        pics= rails_blob_url(@post_id.pics)
        render :json=>{code:"00", message:@post_id, image:pics}
    end

    private

    def findPost
        @post_id = Gallery.find(params[:id])
    end
    
    def post_params
        params.permit(:title, :pics)
    end
end
