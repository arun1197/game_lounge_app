class CommentsController < ApplicationController

	def create
		@comment = Comment.new(comment_params)
		@comment.user = current_user
		if @comment.save
			flash[:success] = "Comment Posted!"
			redirect_to @comment.post
		else
			flash[:danger] = "Comment cannot be blank!"
			redirect_to @comment.post
		end
	end

	def destroy
		@comment = Comment.find(params[:post_id])
		@comment.destroy
    	flash[:success] = "Comment deleted"
    	redirect_to request.referrer || root_url
	end

	private
		def comment_params
			params.require(:comment).permit(:content,:post_id)
		end
	
end
