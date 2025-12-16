require 'rails_helper'

describe "Rules API", type: :request do
  describe "GET /rules" do
    it "returns all rule records" do
      get "/rules"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /rules" do
    let(:rule_params) { attributes_for(:rule) }

    it "creates a new rule when valid parameters are provided" do
      expect { post "/rules", params: { rule: rule_params } }.to change(Rule, :count).by(+1)
      expect(response).to have_http_status :created
    end
  end
end
