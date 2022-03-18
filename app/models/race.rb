class Race < ApplicationRecord
  has_many   :heroes
  validates  :name, presence: true, uniqueness: true
  validates  :buff_type, presence: true
  validates  :buff_type, inclusion: { in: %w(power defense), message: "Buff Type must be power or defense only!" }
  validates  :buff_quantity, presence: true
  validates  :buff_quantity, numericality: { greater_than: 1, less_than_or_equal_to: 1000 }
end
