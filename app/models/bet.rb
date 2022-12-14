class Bet < ApplicationRecord
  belongs_to :user
  belongs_to :item
  after_create :generate_serial_number

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

    event :cancel, after: :refund do
      transitions from: :betting, to: :cancelled
    end
  end

  def generate_serial_number
    number_count = Bet.where(item_id: item.id, batch_count: item.batch_count).count.to_s.rjust(4, '0')
    self.update(serial_number: "#{Time.current.strftime("%y%m%d")}-#{item.id}-#{item.batch_count}-#{number_count}")
  end
end

