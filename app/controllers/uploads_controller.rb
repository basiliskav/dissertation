class UploadsController < ApplicationController

# respond_to :docx, :html

  def show
    @upload = Upload.find(params[:id])
    # respond_with(@upload, filename: @upload.attachment)
  end

  def new
    curr_user
    @upload = @user.uploads.new
    @fid = params[:fid]
    @back_folder = Folder.where(id: @fid).take if @fid
  end

  def create
    curr_user
    @upload = @user.uploads.create(upload_params)
    if @upload.save
      redirect_to folders_path, notice: t('upload_notice')
    else
      render "new"
    end
  end

  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy
    redirect_to folders_path, notice: t('delete_notice')
  end

  def curr_user
    @user = current_user
  end

  private
  def upload_params
    params.require(:upload).permit(:attachment, :folder_id)
  end
end
