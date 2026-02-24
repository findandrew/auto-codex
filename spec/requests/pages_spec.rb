require "rails_helper"

RSpec.describe "Pages", type: :request do
  it "renders hello world on root path" do
    get root_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Hello, world! Welcome to AutoCodex. Hope you are having a nice day :) Preview verification branch message.")
  end
end
