require 'rails_helper'

describe "Rules API", type: :request do
  describe "GET /rules" do
    it "returns all rule records" do
      get "/api/v1/rules"
      expect(response).to have_http_status(:ok)
    end

    it "returns an empty array when no rules exist" do
      get "/api/v1/rules"
      expect(JSON.parse(response.body)).to eq([])
    end
  end

  describe "POST /rules" do
    let(:rule_params) { attributes_for(:rule) }

    it "creates a new rule when valid parameters are provided" do
      expect {
        post "/api/v1/rules", params: { rule: rule_params }
      }.to change(Rule, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(response.content_type).to include("application/json")
      expect(response.headers["Location"]).to match(%r{/api/v1/rules/\d+})

      json = JSON.parse(response.body)

      expect(json).to include("id", "field", "operator", "value", "name")
      expect(json["name"]).to eq(rule_params[:name])
      expect(json["created_at"]).to be_present
      expect(json["updated_at"]).to be_present
    end

    it "does not create a rule when validation fails" do
      invalid_params = rule_params.merge(name: "")

      expect {
        post "/api/v1/rules", params: { rule: invalid_params }
      }.to change(Rule, :count).by(0)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns a validation error response when duplicate name is provided" do
      post "/api/v1/rules", params: { rule: rule_params }
      post "/api/v1/rules", params: { rule: rule_params }

      expect(response).to have_http_status(:unprocessable_entity)

      json = JSON.parse(response.body)

      expect(json["type"]).to eq("https://example.com/problems/validation-error")
      expect(json["validation"]).to be_an(Array)
    end

    it "returns a validation error response when invalid operator is provided" do
      post "/api/v1/rules",
        params: {
          rule: rule_params.merge(
            value: "10",
            operator: "contains"
          )
        }

      expect(response).to have_http_status(:unprocessable_entity)

      json = JSON.parse(response.body)

      expect(json["type"]).to eq("https://example.com/problems/validation-error")
      expect(json["validation"]).to be_an(Array)
    end
  end
end
