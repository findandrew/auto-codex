require "rails_helper"

RSpec.describe "Registrations", type: :request do
  describe "GET /new" do
    it "renders signup page" do
      get new_registration_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Create account")
    end
  end

  describe "POST /registration" do
    it "creates a user and starts a session" do
      expect do
        post registration_path, params: {
          user: {
            email_address: "new-user@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        }
      end.to change(User, :count).by(1).and change(Session, :count).by(1)

      expect(response).to redirect_to(projects_path)
    end

    it "returns unprocessable content for invalid input" do
      post registration_path, params: {
        user: {
          email_address: "",
          password: "password123",
          password_confirmation: "mismatch"
        }
      }

      expect(response).to have_http_status(:unprocessable_content)
    end
  end
end
