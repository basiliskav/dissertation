class UsersController < ApplicationController

  def index
    # @users = User.paginate(page: params[:page])
    @users = User.where(:is_active => true )
  end

  def destroy
    @user = User.find(params[:id])
    @user.is_active = false
    @user.save!
    flash[:success] = "User deleted."
    redirect_to users_url
  end
end
