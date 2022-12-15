class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # ---------------------------------------------------------------------------
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  mount_uploader :image, ImageUploader
  validates :phone, phone: { possible: true, allow_blank: true, types: [:voip, :mobile], countries: :ph }
  enum role: { client: 0, admin: 1 }
  has_many :bets
  has_many :winners
  has_many :homes
  has_many :addresses
  has_many :children, class_name: "User", foreign_key: 'parent_id'
  belongs_to :parent, class_name: "User", optional: true, counter_cache: :children_members
end
