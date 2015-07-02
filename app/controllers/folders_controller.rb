class FoldersController < ApplicationController
  def index
    @user = current_user
  end

  def new
    @folder = Folder.new
  end

  def create
    @folder = Folder.new(folder_params)
    @folder.user_id = current_user.id
    if @folder.save
      redirect_to folders_path
    else
      render 'new'
    end
  end
  private
  def folder_params
    params.require(:folder).permit(:name)
  end
end
