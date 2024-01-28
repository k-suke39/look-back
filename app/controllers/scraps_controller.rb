# frozen_string_literal: true

class ScrapsController < ApplicationController
  before_action :authenticate_user!, except: %i[show index]
  before_action :set_scrap, only: %i[show edit update destroy]

  def index
    @scraps = Scrap.includes(:tags).order(created_at: :desc)
  end

  def show
    @comments = @scrap.comments.includes(:user).order(created_at: :desc)
    @comment = Comment.new
  end

  def new
    @scrap = Scrap.new
  end

  def create
    @scrap = current_user.scraps.new(scrap_params)
    if @scrap.save_with_tags(tag_names: params.dig(:scrap, :tag_names).split(',').uniq)
      flash[:notice] = '記録しました'
      redirect_to scraps_path
    else
      flash[:alert] = '記録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @scrap.assign_attributes(scrap_params)
    if @scrap.save_with_tags(tag_names: params.dig(:scrap, :tag_names).split(',').uniq)
      flash[:notice] = '記録を更新しました'
      redirect_to scraps_path
    else
      flash[:alert] = '記録の更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if (@scrap.user = current_user)
      @scrap.destroy
      flash[:notice] = '記録が削除されました'
    end
    redirect_to scraps_path
  end

  private

  def set_scrap
    @scrap = current_user.scraps.find_by(id: params[:id])
  end

  def scrap_params
    params.require(:scrap).permit(:title, :content)
  end
end
