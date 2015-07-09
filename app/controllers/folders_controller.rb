class FoldersController < ApplicationController

 def index
    @user = current_user
    @archives = @user.archives
  end

  def new
    @folder = Folder.new
    @fid = params[:fid]
  end

  def show
    find_folder
  end

  def create
    @folder = Folder.new(folder_params)
    @folder.user_id = current_user.id
    if @folder.save
      redirect_to folder_path(@folder)
    else
      render 'new'
    end
  end

  def edit
    find_folder
  end

  def update
    find_folder
    if @folder.update_attributes(folder_params)
      redirect_to folders_path
    else
      render 'edit'
    end
  end

  def destroy
    find_folder
    @folder.destroy
    redirect_to folders_url
  end

  private
  def folder_params
    params.require(:folder).permit(:name, :parent_id)
  end

  def find_folder
    @folder = Folder.find(params[:id])
  end
end
