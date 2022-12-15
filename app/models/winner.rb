class Winner < ApplicationRecord
  belongs_to :user
  belongs_to :item
  belongs_to :bet
  belongs_to :address
  belongs_to :admin, class_name: "User"

  include AASM
  aasm column: :state do
    state :won, initial: true
    state :claimed, :submitted, :paid, :shipped, :delivered, :shared, :published, :remove_published

    event :claim do
      transitions from: :won, to: :claimed
    end
    event :submit do
      transitions from: :claimed, to: :submitted
    end
    event :pay do
      transitions from: :submitted, to: :paid
    end
    event :ship do
      transitions from: :paid, to: :shipped
    end
    event :deliver do
      transitions from: :shipped, to: :delivered
    end
    event :share do
      transitions from: :delivered, to: :shared
    end
    event :publish do
      transitions from: [:shared, :remove_published], to: :published
    end
    event :remove_publish do
      transitions from: :published, to: :remove_published
    end
  end
end
