class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :admin_or_correct_user, only: [:show, :edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: :show
  
  

  def index
    @users = User.paginate(page: params[:page])
    # @users = @users.where('name LIKE ?', "%#{params[:search]}%") if params[:search].present?
   @user = User.new
  end
  
  
  def import
    if params[:file].blank?
      flash[:danger] = "ファイルを選択してください。"
      redirect_to users_url
    else
    User.import(params[:file])
    flash[:success] = "ファイルをインポートしました。"
    redirect_to users_url
    end
  end

  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to index
    else
      render :edit      
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

  def edit_basic_info
  end

  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  def admin_or_correct_user
    @user = User.find(params[:id])
    unless current_user?(@user) || current_user.admin?
      flash[:danger]="権限がありません"
      redirect_to(root_url)
    end
  end
  
  def index_attendance
    @users = User.all.includes(:attendances)
  end
  
  def base
  end
  

  private

    def user_params
      params.require(:user).permit(:name, :email, :department,  :password, :password_confirmation, :employee_number, :card,
                                   :basic_time, :designated_work_start_time, :designated_work_end_time,)
    end

    def basic_info_params
      params.require(:user).permit(:department, :employee_number, :card, :designated_work_start_time, :designated_work_end_time, :basic_time, :work_time)
    end
end
