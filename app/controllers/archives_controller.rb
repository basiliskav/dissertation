class ArchivesController < ApplicationController
  def new
    @file = Archive.new
    @fid = params[:fid]
  end 

 def create
    @file = Archive.new(file_params)
    @file.user_id = current_user.id
    if @file.save
      redirect_to archive_path(@file)
    else
      render 'new'
    end
 end

 def show
    @file = Archive.find(params[:id])
    @user = current_user.id
 end

 
 def edit
    @file = Archive.find(params[:id])
 end

 def update
    @file = Archive.find(params[:id])
    if @file.update_attributes(file_params)
      redirect_to folders_path
    else
      render 'edit'
    end
 end

  private

  def file_params
    params.require(:archive).permit(:name, :text, :folder_id) 
  end
end
