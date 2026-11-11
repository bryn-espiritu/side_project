class Order < ApplicationRecord
  belongs_to :user
  belongs_to :offer, optional: true
  after_create :generate_serial_number

  validates_presence_of :remarks, unless: :deposit?
  validates_numericality_of :coin
  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4 }

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :pay do
      transitions from: :submitted, to: :paid, guard: :not_deduct?, after: [:increment_coins, :increment_deposit]
      transitions from: :submitted, to: :paid, guard: :enough_coins?, after: [:increment_coins, :increment_deposit]
    end

    event :cancel do
      transitions from: [:pending, :submitted], to: :cancelled
      transitions from: :paid, to: :cancelled, guard: :not_deduct?, after: [:cancel_coin_update, :decrement_deposit]
      transitions from: :paid, to: :cancelled, guard: :enough_coins?, if: proc { !deduct? }, after: :cancel_coin_update
    end
  end

  def generate_serial_number
    number_count = Order.where(user_id: user.id).count.to_s.rjust(4, "0")
    self.update(serial_number: "#{Time.current.strftime("%y%m%d")}-#{id}-#{user.id}-#{number_count}")
  end

  def increment_coins
    if deduct?
      self.user.update!(coins: self.user.coins - coin)
    else
      self.user.update!(coins: self.user.coins + coin)
    end
  end

  def increment_deposit
    if deposit?
      self.user.update!(total_deposit: self.user.total_deposit + amount)
    end
  end

  def decrement_deposit
    if deposit?
      self.user.update!(total_deposit: self.user.total_deposit - amount)
    end
  end

  def cancel_coin_update
    if deduct?
      self.user.update!(coins: user.coins + coin)
    else
      self.user.update!(coins: user.coins - coin)
    end
  end

  def enough_coins?
    user.coins => coin
  end

  def not_deduct?
    !deduct?
  end

end

