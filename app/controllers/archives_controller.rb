class ArchivesController < ApplicationController

  def new
    curr_user
    @archive = @user.archives.new
    @fid = params[:fid]
  end

  def create
    curr_user
    @archive = @user.archives.create(archive_params)
    if @archive.save
      redirect_to folder_archive_path(@archive.folder_id, @archive.id)
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
    curr_user
    @archive = @user.archives.where(id: params[:id],user_id: @user.id).take
  end

  def curr_user
    @user = current_user
  end
end
