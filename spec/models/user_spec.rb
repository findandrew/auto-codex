require "rails_helper"

RSpec.describe User, type: :model do
  it "normalizes email to lowercase without surrounding spaces" do
    user = described_class.create!(
      email_address: "  USER@Example.COM ",
      password: "password123",
      password_confirmation: "password123"
    )

    expect(user.reload.email_address).to eq("user@example.com")
  end
end
