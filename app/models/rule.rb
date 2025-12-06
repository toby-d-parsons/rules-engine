class Rule < ApplicationRecord
  validates :field, :operator, :value, :name, presence: true
end
