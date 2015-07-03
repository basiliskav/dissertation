class Folder < ActiveRecord::Base
  belongs_to :user
  has_many :subfolders, :class_name => "Folder", :foreign_key => "parent_id"
  belongs_to :parent, :class_name => "Folder"
end
