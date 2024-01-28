class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = current_user.comments.new(comment_params)
    if @comment.save 
      flash[:notice] = 'コメントの投稿に成功しました'
      redirect_to scrap_path(params[:scrap_id])
    end
  end

  def destroy
    @comment = current_user.comments.find_by(id: params[:id])
    @comment.destroy!
    flash[:notice] = 'コメントの削除に成功しました'
    redirect_to scrap_path(@comment.scrap_id)
  end


  private
  def comment_params
    params.require(:comment).permit(:content).merge(scrap_id: params[:scrap_id])
  end
end
