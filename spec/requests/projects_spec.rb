require "rails_helper"

RSpec.describe "Projects", type: :request do
  let(:user) { User.create!(email_address: "owner@example.com", password: "password123", password_confirmation: "password123") }
  let(:valid_attributes) { { name: "AutoCodex", summary: "Agentic setup", status: "planned" } }
  let(:invalid_attributes) { { name: "", summary: "Missing name", status: "invalid" } }

  describe "authentication guard" do
    it "redirects unauthenticated requests to sign in" do
      get projects_url

      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "CRUD actions when signed in" do
    before { sign_in(user) }

    it "lists projects" do
      Project.create!(valid_attributes)

      get projects_url

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Projects")
    end

    it "creates a project" do
      expect do
        post projects_url, params: { project: valid_attributes }
      end.to change(Project, :count).by(1)

      expect(response).to redirect_to(project_url(Project.last))
    end

    it "rejects invalid create" do
      post projects_url, params: { project: invalid_attributes }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("errors prohibited this project from being saved")
    end

    it "updates a project" do
      project = Project.create!(valid_attributes)

      patch project_url(project), params: { project: { status: "active" } }

      expect(response).to redirect_to(project_url(project))
      expect(project.reload.status).to eq("active")
    end

    it "destroys a project" do
      project = Project.create!(valid_attributes)

      expect do
        delete project_url(project)
      end.to change(Project, :count).by(-1)

      expect(response).to redirect_to(projects_url)
    end
  end
end
