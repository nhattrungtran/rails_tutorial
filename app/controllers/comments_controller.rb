class CommentsController < ApplicationController
  def create
  	session[:return_to] ||= request.referer
  	@comment = Comment.new(content: params[:comment][:content], user_id: current_user.id, micropost_id: params[:comment][:micropost_id])
    if @comment.save
      flash[:success] = "Bình luận thành công!"
      redirect_to session.delete(:return_to)
    else
	    @current_micropost = current_user.microposts.find_by(id: params[:comment][:micropost_id])
	    @comment = Comment.new

	    @comments = @current_micropost.comments.paginate(page: params[:page])
	    render 'microposts/show'
    end
  end

  def update
  	@comment = Comment.find(params[:id])
  	session[:return_to] ||= request.referer
  	if @comment.update_attributes(content: params[:comment][:content])
  		flash[:success]	= "Chỉnh sửa thành công!"
  		redirect_to session.delete(:return_to)
  	else
  		flash[:danger]  = "Chỉnh sửa thất bại"
  		redirect_to session.delete(:return_to)
  	end
  end

  def destroy
  	@comment = Comment.find(params[:id])
  	@comment.destroy
    flash[:success] = "Xóa bình luận thành công"
    session[:return_to] ||= request.referer
    redirect_to session.delete(:return_to)
  end

  # private

  #   def user_params
  #     params.require(:comment).permit(:content, :email, :password,
  #                                  :password_confirmation)
  #   end
end
