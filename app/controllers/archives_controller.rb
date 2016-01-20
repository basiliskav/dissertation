class ArchivesController < ApplicationController

  respond_to :docx, :html

  before_action :curr_user
  before_action :find_archive, only:[:show,:destroy,:edit,:update]

  def show
    @a=@archive.text
    respond_with(@archive, filename: @archive.name, word_template: "show.docx")
  end

  def new
    @archive = @user.archives.new
    @fid = params[:fid]
    @back_folder = Folder.where(id: @fid).take if @fid
  end

  def create
    @archive = @user.archives.create(archive_params)
    if @archive.save
      custom_redirect
    else
      render 'new'
    end
  end

  def edit
    @back_folder = Folder.find(@archive.folder_id) if @archive.folder_id != 1000
  end

  def update
    if @archive.update_attributes(archive_params)
      custom_redirect
    else
      render 'edit'
    end
  end

  def destroy
    @archive.destroy
    custom_redirect
  end

  private
  def archive_params
    params.require(:archive).permit(:name, :text, :folder_id)
  end

  def find_archive
    @archive = @user.archives.where(id: params[:id],user_id: @user.id).take
  end

  def curr_user
    @user = current_user
  end

  def custom_redirect
    redirect_to folders_path if @archive.folder_id == 1000
    redirect_to folder_path(Folder.find(@archive.folder_id)) if @archive.folder_id != 1000
  end
end
