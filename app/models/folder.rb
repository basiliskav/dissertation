class Folder < ActiveRecord::Base

  validates :name, presence: true

  belongs_to :user
  belongs_to :parent, :class_name => "Folder"

  has_many :subfolders, :class_name => "Folder", :foreign_key => "parent_id", dependent: :destroy
  has_many :archives, :class_name => "Archive", :foreign_key => "folder_id", dependent: :destroy
  has_many :uploads, :class_name => "Upload", :foreign_key => "folder_id", dependent: :destroy

end
