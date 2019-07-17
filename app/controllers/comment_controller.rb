class CommentController < ApplicationController
    before_action :authorize_request, except:[:getAllComment]

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

    private
    def comment_param
        params.permit(:comment)
    end
   
end
