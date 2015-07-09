class ArchivesController < ApplicationController

  def new
    @archive = Archive.new
    @fid = params[:fid]
  end

  def create
    @archive = Archive.new(archive_params)
    @archive.user_id = current_user.id
    @archive.folder_id = 1 if @archive.folder_id.nil?
    if @archive.save
      redirect_to folders_path #folder_archive_path(current_user.id)
    else
      render 'new'
    end
  end

  def show
    @user = current_user
    @archive = @user.archives.find(16)
    # find_archive
  end

  def edit
    find_archive
  end

  def update
    find_archive
    if @archive.update_attributes(archive_params)
      redirect_to folders_path
    else
      render 'edit'
    end
  end

  def destroy
    @folder = Folder.find(params[:folder_id])
    @archive = @folder.archives.find(params[:id])
   	@archive.destroy
   	redirect_to folders_path(@folder)
  end

  private
  def archive_params
    params.require(:archive).permit(:name, :text, :folder_id)
  end

  def find_archive
    @archive = Archive.find(params[:id])
  end

end
