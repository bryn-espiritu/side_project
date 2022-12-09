class Item < ApplicationRecord
  has_many :item_category_ships
  has_many :categories, through: :item_category_ships
  # validates_presence_of :image
  # validates_presence_of :name
  # validates_presence_of :quantity
  # validates_presence_of :minimum_bets
  # validates_presence_of :state
  # validates_presence_of :batch_count
  # validates_presence_of :online_at
  # validates_presence_of :offline_at
  # validates_presence_of :start_at
  # validates_presence_of :status

  mount_uploader :image, ImageUploader
  enum status: { active: 0, inactive: 1 }

  default_scope { where(deleted_at: nil) }
  def destroy
    update(deleted_at: Time.current)
  end

end
