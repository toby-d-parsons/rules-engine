class Rule < ApplicationRecord
  validates :field, :operator, :value, presence: true
  validates :name, presence: true, uniqueness: true
end
