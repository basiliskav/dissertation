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
    find_archive
    @user = current_user.id
 end

 
 def edit
    find_archive
 end

 def update
    find_archive
    if @file.update_attributes(file_params)
      redirect_to folders_path
    else
      render 'edit'
    end
 end

 def destroy
 	find_archive
 	@file.destroy
 	redirect_to folders_path
 end

  private

  def file_params
    params.require(:archive).permit(:name, :text, :folder_id) 
  end

  def find_archive
  	@file = Archive.find(params[:id])
  end
end
