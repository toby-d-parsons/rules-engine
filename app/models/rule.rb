class Rule < ApplicationRecord
  attr_accessor :unparsed_value

  validates :field, :operator, :value, presence: true
  validate  :operator_is_allowed_for_value
  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 255 }

  def operator_is_allowed_for_value
    return if allowed_operators_for_value_datatype.include?(operator)

    errors.add(:operator,
               :invalid,
                message:  "`#{operator}` is not valid for #{infer_value_datatype} values. " \
                          "Allowed #{infer_value_datatype} operators: #{allowed_operators_for_value_datatype.join(', ')}"
    )
  end

  def allowed_operators_for_value_datatype
    OperatorRegistry.allowed_for(infer_value_datatype)
  end

  private

  def infer_value_datatype
      case
      when boolean?(unparsed_value)  then :boolean
      when numeric?(unparsed_value)  then :numeric
      when datetime?(unparsed_value) then :datetime
      when date?(unparsed_value)     then :date
      else                                :string
      end
  end

  def boolean?(unparsed_value)
    unparsed_value.is_a?(TrueClass) || unparsed_value.is_a?(FalseClass)
  end

  def numeric?(value)
    Float(value)
    true
  rescue ArgumentError, TypeError
    false
  end

  def datetime?(value)
    Time.iso8601(value.to_s)
    true
  rescue ArgumentError, TypeError
    false
  end

  def date?(value)
    Date.iso8601(value.to_s)
    true
  rescue ArgumentError, TypeError
    false
  end
end
