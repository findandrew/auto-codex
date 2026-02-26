require "rails_helper"

RSpec.describe Project, type: :model do
  it "is valid with required attributes" do
    project = described_class.new(name: "AutoCodex", status: "planned")

    expect(project).to be_valid
  end

  it "requires a name" do
    project = described_class.new(status: "planned")

    expect(project).not_to be_valid
    expect(project.errors[:name]).to include("can't be blank")
  end

  it "enforces allowed statuses" do
    project = described_class.new(name: "AutoCodex", status: "unknown")

    expect(project).not_to be_valid
    expect(project.errors[:status]).to include("is not included in the list")
  end
end
