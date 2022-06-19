class BasesController < ApplicationController
    # before_action :set_user, only: [ :show,:destroy]
    # before_action :logged_in_user, only: [:index,   :destroy]
    # # before_action :correct_user, only: [ :update]
    # before_action :admin_user, only: [ :update]
    

  def index
    @bases = Base.all
    @base = Base.new
  end
  
  def show
    redirect_to index
  end
  
  def new
    redirect_to index
  end
  
  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = '拠点情報が追加されました。'
      redirect_to @base
    else
      flash[:danger] = '無効なデータがあります。'
      redirect_to @base
    end
  end
  
  def edit
    @base = Base.find(params[:id])
  end
  
  def update
     @base = Base.find(params[:id])
    if @base.update(base_params)
      # 更新に成功した場合の処理を記述します。
      flash[:success] = "拠点情報を更新しました。"
      redirect_to @base
    else
      flash[:danger] = '修正に失敗しました。'
      render :edit      
    end
  end
  
  def destroy
    @base = Base.find(params[:id])
    @base.destroy
    flash[:success] = "#{@base.base_name}のデータを削除しました。"
    redirect_to @base
  end
  
  
    private

    def base_params
      params.require(:base).permit(:base_number, :base_name, :base_type)
    end
end