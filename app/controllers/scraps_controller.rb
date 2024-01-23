# frozen_string_literal: true

class ScrapsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
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
      redirect_to root_path
    else
      flash[:alert] = '記録に失敗しました'
      render :new
    end
  end

  private

  def scrap_params
    params.require(:scrap).permit(:title, :content)
  end
end
