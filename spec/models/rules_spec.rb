require 'rails_helper'

RSpec.shared_examples "a valid operator" do
  it { is_expected.to be_valid }
end

RSpec.shared_examples "an invalid operator" do |operator:, datatype:, allowed_arr:|
  it "adds an operation validation error" do
    subject.valid?

    expect(subject.errors.details[:operator])
          .to include(hash_including(error: :invalid))
  end

  it "includes operator, datatype, and allowed operators in the error message" do
    subject.valid?

    message = subject.errors.full_messages.join(" ")

    expect(message).to include(operator)
    expect(message).to include(datatype)
    allowed_arr.each { |op| expect(message).to include(op) }
  end
end

describe Rule, type: :model do
  context "when a mandatory field is missing" do
    %i[field operator value name].each do |attr|
      it "requires #{attr}" do
        rule = build(:rule, attr => nil)
        rule.valid?

        expect(rule.errors.details[attr])
              .to include(hash_including(error: :blank))
      end
    end
  end

  describe "name validation" do
    context "when name is too short" do
      subject { build(:rule, name: "ab") }
      it "adds a length validation error" do
        subject.valid?

        expect(subject.errors.details[:name])
              .to include(hash_including(error: :too_short))
      end
    end

    context "when name is too long" do
      subject { build(:rule, name: "a" * 256) }
      it "adds a length validation error" do
        subject.valid?

        expect(subject.errors.details[:name])
          .to include(hash_including(error: :too_long))
      end
    end

    context "when name is not unique" do
      subject { build(:rule, name: "duplicate") }
      before  { create(:rule, name: "duplicate") }
      it "adds a uniqueness validation error" do
        subject.valid?

        expect(subject.errors.details[:name])
              .to include(hash_including(error: :taken))
      end
    end
  end

  describe "operator validation" do
    context "when the value is inferred as boolean" do
      context "with a valid operator" do
        subject { build(:rule, operator: "equals", value: "true", unparsed_value: true) }
        include_examples "a valid operator"
      end

      context "with an invalid operator" do
        subject { build(:rule, operator: "invalid_operator", value: "true", unparsed_value: true) }
        include_examples "an invalid operator",
          operator: "invalid_operator",
          datatype: "boolean",
          allowed_arr:  OperatorRegistry.allowed_for(:boolean)
      end
    end

    context "when the value is inferred as numeric" do
      context "with a valid operator" do
        subject { build(:rule, operator: "greater_than", value: "50", unparsed_value: 50) }
        include_examples "a valid operator"
      end

      context "with an invalid operator" do
        subject { build(:rule, operator: "contains", value: "50", unparsed_value: 50) }
        include_examples "an invalid operator",
          operator: "contains",
          datatype: "numeric",
          allowed_arr:  OperatorRegistry.allowed_for(:numeric)
      end
    end

    context "when the value is inferred as datetime" do
      context "with a valid ISO-8601 datetime operator" do
        subject { build(:rule, operator: "before", value: "2025-12-29T18:10:48", unparsed_value: "2025-12-29T18:10:48") }
        include_examples "a valid operator"
      end

      context "with an invalid operator" do
        subject { build(:rule, operator: "contains", value: "2025-12-29T18:10:48", unparsed_value: "2025-12-29T18:10:48") }
        include_examples "an invalid operator",
          operator: "contains",
          datatype: "datetime",
          allowed_arr:  OperatorRegistry.allowed_for(:datetime)
      end
    end

    context "when the value is inferred as date" do
      context "with a valid ISO-8601 date operator" do
        subject { build(:rule, operator: "before", value: "2017-06-01", unparsed_value: "2017-06-01") }
        include_examples "a valid operator"
      end

      context "with an invalid operator" do
        subject { build(:rule, operator: "contains", value: "2017-06-01", unparsed_value: "2017-06-01") }
        include_examples "an invalid operator",
          operator: "contains",
          datatype: "date",
          allowed_arr:  OperatorRegistry.allowed_for(:date)
      end
    end

    context "when the value defaults to string when no other datatype matches" do
      context "with a valid operator" do
        subject { build(:rule, operator: "ends_with", value: "example_string", unparsed_value: "example_string") }
        include_examples "a valid operator"
      end

      context "treats string booleans as strings, not booleans" do
        subject { build(:rule, operator: "ends_with", value: "true", unparsed_value: "true") }
        include_examples "a valid operator"
      end

      context "with an invalid operator" do
        subject { build(:rule, operator: "greater_than", value: "example_string", unparsed_value: "example_string") }
        include_examples "an invalid operator",
          operator: "greater_than",
          datatype: "string",
          allowed_arr:  OperatorRegistry.allowed_for(:string)
      end
    end
  end
end
