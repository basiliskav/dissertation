class Archive < ActiveRecord::Base

  validates :name, presence: true

  belongs_to :user
  belongs_to :folder#, dependent: :delete

end
