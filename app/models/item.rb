class Item < ApplicationRecord
  has_many :item_category_ships
  has_many :bets
  has_many :categories, through: :item_category_ships
  has_many :winners
  # validates_presence_of :image, :name, :quantity, :minimum_bets, :state, :batch_count, :online_at, :offline_at, :start_at, :status\

  mount_uploader :image, ImageUploader
  enum status: { active: 0, inactive: 1 }

  default_scope { where(deleted_at: nil) }
  def destroy
    update(deleted_at: Time.current)
  end

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :ended, :cancelled], to: :starting, after: :batch_quantity, guards: [:greater_than_zero?, :future?, :active?]
      transitions from: :paused, to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended, guards: [:enough_bets, :winner_has_address?], after: :picked_winner
    end

    event :cancel, after: [:add_quantity, :coin_return] do
      transitions from: [:starting, :paused], to: :cancelled
    end
  end

  def add_quantity
    @add_quantity = self.quantity + 1
    update(quantity: @add_quantity)
  end

  def batch_quantity
    self.update(quantity: self.quantity - 1, batch_count: self.batch_count + 1)
  end

  def greater_than_zero?
    quantity > 0
  end

  def coin_return
    bets.where(batch_count: batch_count).where.not(state: :cancelled).each {|bet| bet.cancel!}
  end

  def future?
    Time.now < offline_at
  end

  def eligible_bets
    bets.where(batch_count: batch_count, state: 'betting')
  end

  def enough_bets
    minimum_bets.present? && minimum_bets.positive? && eligible_bets.count >= minimum_bets
  end

  # Do not draw until every participant can receive their prize.
  def winner_has_address?
    user_ids = eligible_bets.select(:user_id)
    users_with_address = User.joins(:addresses).where(addresses: { is_default: true }).select(:id)
    !User.where(id: user_ids).where.not(id: users_with_address).exists?
  end

  def picked_winner
    winner = eligible_bets.to_a.sample
    raise ActiveRecord::RecordNotFound, 'No eligible bets to draw' unless winner

    address = winner.user.addresses.find_by!(is_default: true)
    winner.win!
    eligible_bets.update_all(state: 'lost')
    Winner.create!(item_batch_count: winner.batch_count, user: winner.user,
                   item: winner.item, bet: winner, address: address)
  end
end
