class Upload < ActiveRecord::Base

  validates :attachment, presence: true

  mount_uploader :attachment, AttachmentUploader

  belongs_to :user
  belongs_to :folder#, dependent: :delete

end
