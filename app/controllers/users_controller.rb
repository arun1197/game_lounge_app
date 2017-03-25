class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  rescue_from ActiveRecord::RecordNotFound, :with => :user_not_found

  def user_not_found
    flash[:info] = "User does not exist."
    redirect_to root_url
  end

  # GET /users
  # users_path
  def index
    @users = User.paginate(page: params[:page])
  end
  # GET /user/{id}
  # user_path(user)
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page])
  end

  # GET /users/new
  # new_user_path
  def new
  	@user = User.new
  end

  # POST /users
  # users_path
  def create
  	@user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # or user_url(@user)
    else
      render 'new'
    end
  end

  # GET /users/1/edit
  # edit_user_path
  def edit
    @user = User.find(params[:id])
  end

  #PATCH /users/{id}
  # user_path(user)
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params_with_desc)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  # Before filters

  private
  	def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def user_params_with_desc
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :description)
    end

    #Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
