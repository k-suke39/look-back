# frozen_string_literal: true

class RelationshipsController < ApplicationController
  def create
    user = User.find(params[:user_id])
    current_user.follow(user)
    flash[:notice] = 'フォローに成功しました'
    redirect_to scraps_path
  end

  def destroy
    user = User.find(params[:id])
    current_user.unfollow(user)
    flash[:notice] = 'フォローを外すことに成功しました'
    redirect_to scraps_path
  end
end
