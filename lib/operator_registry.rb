module OperatorRegistry
  OPERATORS = {
    string:   %w[equals not_equals contains starts_with ends_with],
    numeric:  %w[equals not_equals greater_than less_than between],
    datetime: %w[before after between],
    date:     %w[before after between],
    boolean:  %w[equals not_equals]
  }.freeze

  def self.allowed_for(type)
    OPERATORS[type] || []
  end
end
