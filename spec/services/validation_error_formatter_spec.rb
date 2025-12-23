require 'rails_helper'

describe ValidationErrorFormatter, type: :service do
  let(:rule) do
    Rule.new(name: "", value: "")
  end

  before do
    rule.validate
  end

  subject(:payload) do
    described_class.call(
      rule.errors,
      ProblemTypes::VALIDATION_ERROR
    )
  end

  it "returns an RFC 7807 compliant error response" do
    expect(payload).to include(
      type: "https://example.com/problems/validation-error",
      title: "The payload is invalid"
    )
  end

  it "includes validation errors" do
    expect(payload[:validation]).to be_an(Array)
    expect(payload[:validation]).not_to be_empty
  end

  it "handles multiple validation errors on the same field" do
    expect(payload[:validation].count { |e| e[:field] == "name" }).to be >= 1
  end
end
