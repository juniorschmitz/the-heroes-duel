class Hero < ApplicationRecord
  belongs_to :race
  validates  :name, presence: true, uniqueness: true
  validates  :power, presence: true
  validates  :defense, presence: true
  validates  :power, numericality: { greater_than: 1, less_than_or_equal_to: 1000 }
  validates  :defense, numericality: { greater_than: 0, less_than_or_equal_to: 1000 }

  def upgraded_hero
    race = self.race
    case race.buff_type
    when 'power'
      self.power += race.buff_quantity
    when 'defense'
      self.defense += race.buff_quantity
    end
    self
  end
end
