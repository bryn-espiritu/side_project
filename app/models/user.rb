class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
   validates :phone, phone: { possible: true, allow_blank: true, types: [:voip, :mobile], countries: :ph }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  mount_uploader :image, ImageUploader
  enum role: { client: 0, admin: 1 }
  has_many :homes

end
