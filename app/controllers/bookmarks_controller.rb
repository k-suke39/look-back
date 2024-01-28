# frozen_string_literal: true

class BookmarksController < ApplicationController
  def create
    @scrap = Scrap.find(params[:scrap_id])
    current_user.bookmark(@scrap)
    flash[:notice] = 'ブックマークに成功しました'
    redirect_to scraps_path
  end

  def destroy
    scrap = current_user.bookmarks.find(params[:id]).scrap
    current_user.unbookmark(scrap)
    flash[:notice] = 'ブックマークの削除に成功しました'
    redirect_to scraps_path
  end
end
