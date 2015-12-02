class FoldersController < ApplicationController

  before_action :curr_user
  before_action :find_folder, only:[:show,:edit,:update,:destroy]

  def index
    @archives = @user.archives
    @folders = @user.folders
    @uploads = @user.uploads
  end

  def show
    # @folder.subfolders
      @subfolders = @folder.subfolders.where(user_id: @user.id)
    # end
    @archives = @folder.archives.where(user_id: @user.id)
    @uploads = @folder.uploads.where(user_id: @user.id)
    @back_folder = Folder.find(@folder.parent_id) if @folder.parent_id != 1000
  end

  def new
    @folder = @user.folders.new
    @fid = params[:fid]
    @back_folder = Folder.where(id: @fid).take if @fid
  end

  def create
    @folder = @user.folders.create(folder_params)
    if @folder.save
      redirect_to folder_path(@folder)
    else
      render 'new'
    end
  end

  def edit
    @back_folder = Folder.find(@folder.parent_id) if @folder.parent_id != 1000
  end

  def update
    if @folder.update_attributes(folder_params)
      redirect_to folders_path
    else
      render 'edit'
    end
  end

  def destroy
    @folder.destroy
    redirect_to folders_url
  end

  private
  def folder_params
    params.require(:folder).permit(:name, :parent_id)
  end

  def find_folder
    @folder = @user.folders.where(id: params[:id],user_id: @user.id).take
  end

  def curr_user
    @user = current_user
  end
end
