class CommentController < ApplicationController
    before_action :authorize_request, except:[:getAllCommentForGallery]
    before_action :set_gallery, only:[:getAllCommentForGallery]
    before_action :set_comment_user, only:[:editComment]

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

    def editComment
        if @comment.update(comment_param)
            render :json=>{code:"00", message:"update successful"}
        else
            render :json=>{code:"01", message:"error making update"}
        end
    end

    private

    def set_gallery
        @post_id = Gallery.find(params[:id])
    end

    def comment_param
        params.permit(:comment)
    end

    def set_comment_user
        @comment = @current_user.comments.find_by!(id: params[:id]) if @current_user
      end
   
end
