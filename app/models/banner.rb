class Banner < ApplicationRecord
  mount_uploader :preview, ImageUploader
  enum status: { active: 0, inactive: 1 }
  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.now)
  end
end
