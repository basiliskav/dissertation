class FoldersController < ApplicationController
 def index
    @user = current_user
    @files = @user.archives
  end

  def new
      @folder = Folder.new
      @fid = params[:fid]
  end

  def show
    @user = current_user
    @folder = Folder.find(params[:id])
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
    @folder = Folder.find(params[:id])
  end

  def update
    @folder = Folder.find(params[:id]) 
    if @folder.update_attributes(folder_params)
      redirect_to folders_path
    else
      render 'edit'
    end
  end

  def destroy
    @folder = Folder.find(params[:id])  
    @folder.destroy
    redirect_to folders_url
  end

  private
  def folder_params
    params.require(:folder).permit(:name, :parent_id)
  end
end
