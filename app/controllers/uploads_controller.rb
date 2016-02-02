require 'docx'

class UploadsController < ApplicationController


  before_action :curr_user
  before_action :find_upload, only:[:show,:destroy,:download]

  def show
    @ext=@upload.attachment.file.extension
    if @ext=="docx"
      @doc = Docx::Document.open('public/new.docx')
    end
  end

  def new
    @upload = @user.uploads.new
    @fid = params[:fid]
    @back_folder = Folder.where(id: @fid).take if @fid
  end

  def create
    @upload = @user.uploads.create(upload_params)
    if @upload.save
      check_if_docx
      if @upload.folder_id == 1000
        redirect_to folders_path, notice: t('upload_notice')
      else
        redirect_to folder_path(@upload.folder_id), notice: t('upload_notice')
      end
    else
      render "new"
    end
  end

  def destroy
    @upload.destroy
      if @upload.folder_id == 1000
        redirect_to folders_path, notice: t('delete_notice')
      else
        redirect_to folder_path(@upload.folder_id), notice: t('delete_notice')
      end
  end

  def download
    send_file "public/#{@upload.attachment.url}", :x_sendfile=>true
  end

  private
  def find_upload
    @upload = Upload.find(params[:id])
  end

  def curr_user
    @user = current_user
  end

  def upload_params
    params.require(:upload).permit(:attachment, :folder_id)
  end

  def check_if_docx
    if @upload.attachment.file.extension=="docx"
      @archive = @user.archives.create(:name => @upload.attachment_identifier, :text => "#{Docx::Document.open("public/#{@upload.attachment_url}")}", :folder_id => @upload.folder_id)
      @upload.destroy
    end
  end
end
