# frozen_string_literal: true

class ScrapsController < ApplicationController
  before_action :authenticate_user!, except: %i[show index]

  def index
    @scraps = Scrap.limit(10).order(created_at: :desc)
  end

  def show
    @scrap = Scrap.find_by(id: params[:id])
  end

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

  def edit
    @scrap = Scrap.find_by(id: params[:id])
  end

  def update
    @scrap = Scrap.find_by(id: params[:id])

    if @scrap.update(scrap_params)
      flash[:notice] = '記録を更新しました'
      redirect_to scraps_path
    else
      flash[:alert] = '記録の更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def scrap_params
    params.require(:scrap).permit(:title, :content)
  end
end
