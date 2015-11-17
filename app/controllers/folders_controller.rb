class FoldersController < ApplicationController

  def index
    curr_user
    @archives = @user.archives
    @folders = @user.folders
    @uploads = @user.uploads
  end

  def show
    find_folder
    @subfolders = @folder.subfolders.where(user_id: @user.id)
    @archives = @folder.archives.where(user_id: @user.id)
    @uploads = @folder.uploads.where(user_id: @user.id)
    @back_folder = Folder.find(@folder.parent_id) if @folder.parent_id != 1000
  end

  def new
    curr_user
    @folder = @user.folders.new
    @fid = params[:fid]
    @back_folder = Folder.where(id: @fid).take if @fid
  end

  def create
    curr_user
    @folder = @user.folders.create(folder_params)
    if @folder.save
      redirect_to folder_path(@folder)
    else
      render 'new'
    end
  end

  def edit
    find_folder
    @back_folder = Folder.find(@folder.parent_id) if @folder.parent_id != 1000
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
    curr_user
    @folder = @user.folders.where(id: params[:id],user_id: @user.id).take
  end

  def curr_user
    @user = current_user
  end
end
