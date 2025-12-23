class Rule < ApplicationRecord
  validates :field, :operator, :value, presence: true
  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 255 }
end
