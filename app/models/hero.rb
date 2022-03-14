class Hero < ApplicationRecord
  validates :name, presence: true
  validates :race, presence: true
  validates :power, presence: true
  validates :defense, presence: true
end