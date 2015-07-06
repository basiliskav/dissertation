class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :authentication_keys => [:signin]

  attr_accessor :signin

  validates :username, :uniqueness => {:case_sensitive => false}

  has_many :folders, dependent: :destroy
  has_many :archives, dependent: :destroy

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if signin = conditions.delete(:signin)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => signin.downcase }]).first
    else
      where(conditions).first
    end
  end

  def canceled_account
    if self.is_active == false
      self.is_active = true
      self.save!
    end
  end
end
