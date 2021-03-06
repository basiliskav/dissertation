class UsersController < ApplicationController

  def index
    # @users = User.paginate(page: params[:page])
    @users = User.where(:is_active => true )
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    # @user.is_active = false
    # @user.save!
    flash.now[:success] = "User deleted."
    redirect_to users_url
  end

  def update
    @user = User.find(params[:id])
    if @user.admin == true
      @user.admin = false
    else
      @user.admin = true
    end
    @user.save!
    redirect_to users_url
  end

end
