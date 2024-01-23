# frozen_string_literal: true

class ScrapsController < ApplicationController
  before_action :authenticate_user!, except: %i[show index]
  before_action :set_scrap, only: %i[show edit update]
  def index
    @scraps = Scrap.limit(10).order(created_at: :desc)
  end

  def show; end

  def new
    @scrap = Scrap.new
  end

  def create
    @scrap = Scrap.new(scrap_params)
    @scrap.user_id = current_user.id
    if @scrap.save
      flash[:notice] = '記録しました'
      redirect_to scraps_path
    else
      flash[:alert] = '記録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @scrap.update(scrap_params)
      flash[:notice] = '記録を更新しました'
      redirect_to scraps_path
    else
      flash[:alert] = '記録の更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    scrap = Scrap.find_by(id: params[:id])
    if (scrap.user = current_user)
      scrap.destroy
      flash[:notice] = '記録が削除されました'
    end
    redirect_to scraps_path
  end

  private

  def set_scrap
    @scrap = Scrap.find_by(id: params[:id])
  end

  def scrap_params
    params.require(:scrap).permit(:title, :content)
  end
end
