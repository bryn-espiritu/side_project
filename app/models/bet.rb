class Bet < ApplicationRecord
  belongs_to :user
  belongs_to :item
  has_many :winners
  after_create :generate_serial_number, :deducted
  after_validation :enough_coins?

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
    number_count = Bet.where(item_id: item.id, batch_count: item.batch_count).count.to_s.rjust(4, '0')
    self.update(serial_number: "#{Time.current.strftime("%y%m%d")}-#{item.id}-#{item.batch_count}-#{number_count}")
  end

  def refund
    self.user.update!(coins: self.user.coins + coin)
  end

  def deducted
    self.user.update!(coins: self.user.coins - coin)
  end

  def enough_coins?
    if self.user.coins < 1
      errors.add(:base, "Not Enough Coins")
    end
  end

end

