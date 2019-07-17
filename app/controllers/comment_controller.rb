class CommentController < ApplicationController
    before_action :authorize_request, except:[:getAllComment]
    before_action :set_gallery, only:[:getAllCommentForGallery]

    def addComment
        @gallery = Gallery.find(params[:gallery_id])
        @comment = @gallery.comments.create(comment_param)
        @comment.user_id = @current_user.id
        if @comment.save
            render :json=>{code:"00", message:@comment}, status: :ok
        else
            render :json=>{code:"01", message:@comment.errors}, status: :unprocessable_entity
        end
    end

    def getAllCommentForGallery
        @gallery_comment=@post_id.comments
        render :json=>{code:"00", message:@gallery_comment}
    end

    private

    def set_gallery
        @post_id = Gallery.find(params[:id])
    end

    def comment_param
        params.permit(:comment)
    end
   
end
