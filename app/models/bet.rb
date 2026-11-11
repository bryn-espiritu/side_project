class Bet < ApplicationRecord
  belongs_to :user
  belongs_to :item
  has_many :winners

  validates :coin, numericality: { only_integer: true, greater_than: 0 }
  validate :enough_coins?, on: :create
  after_create :generate_serial_number, :deducted

  include AASM
  aasm column: :state do
    state :betting, initial: true
    state :won, :lost, :cancelled

    event :win do
      transitions from: :betting, to: :won
    end

    event :lose do
      transitions from: :betting, to: :lost
    end

    event :cancel do
      transitions from: :betting, to: :cancelled, after: :refund
    end
  end

  def generate_serial_number
    update!(serial_number: "#{Time.current.strftime('%y%m%d')}-#{item_id}-#{batch_count}-#{id}")
  end

  def refund
    user.with_lock { user.update!(coins: user.coins + coin) }
  end

  def deducted
    user.with_lock do
      raise ActiveRecord::RecordInvalid, self if user.coins < coin
      user.update!(coins: user.coins - coin)
    end
  end

  def enough_coins?
    return if user.nil? || coin.nil? || coin <= 0
    errors.add(:base, "Not Enough Coins") if user.coins < coin
  end
end
