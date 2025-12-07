require 'rails_helper'

describe "Rules API", type: :request do
  describe "GET /rules" do
    it "returns all rule records" do
      get "/rules"
      expect(response).to have_http_status(:ok)
    end
    it "bloop bloop" do
      get "/rules"
      expect(response).to have_http_status(:ok)
    end
  end
end
