class ValidationErrorFormatter
  def self.call(errors, problem)
    new(errors, problem).call
  end

  def initialize(errors, problem)
    @errors = errors
    @problem = problem
  end

  def call
    {
      "type": @problem[:type],
      "title": @problem[:title],
      "details": "The payload has one or more validation errors, please fix them and try again.",
      "validation": validation_errors
    }
  end

  private

  def validation_errors
    @errors.map do |error|
      {
        field: error.attribute.to_s,
        message: error.full_message
      }
    end
  end
end
