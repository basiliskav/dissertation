class Archive < ActiveRecord::Base

  validates :name, presence: true, :uniqueness => {:scope => [:folder_id,:user_id]}

  belongs_to :user
  belongs_to :folder#, dependent: :delete

end
