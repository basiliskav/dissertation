class ArchivesController < ApplicationController

  def new
    @archive = Archive.new
    @fid = params[:fid]
  end

  def create
    @user = current_user
    @archive = @user.archives.create(archive_params)
    @archive.folder_id = 1 if @archive.folder_id.nil?
    if @archive.save
      redirect_to folders_path #folder_archive_path(current_user.id)
    else
      render 'new'
    end
  end

  def show
    find_archive
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
    find_archive
    @archive.destroy
    redirect_to folders_path(@folder)
  end

  private
  def archive_params
    params.require(:archive).permit(:name, :text, :folder_id)
  end

  def find_archive
    @user = current_user
    @archive = @user.archives.find(params[:id])
  end
end
