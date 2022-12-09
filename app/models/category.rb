class Category < ApplicationRecord
  has_many :item_category_ships
  has_many :items, through: :item_category_ships

  default_scope {where(delete_at: nil)}
  def destroy
    update(delete_at: Time.now)
  end
end
