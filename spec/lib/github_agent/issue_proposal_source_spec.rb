# frozen_string_literal: true

require "rails_helper"
require "tmpdir"
require "fileutils"
require_relative "../../../lib/github_agent/issue_proposal_source"

RSpec.describe GithubAgent::IssueProposalSource do
  it "extracts roadmap and customer feedback proposals with deduplication" do
    Dir.mktmpdir do |dir|
      FileUtils.mkdir_p(File.join(dir, "docs"))
      File.write(File.join(dir, "docs/ROADMAP.md"), <<~MD)
        # Roadmap
        - [ ] Add export endpoint
        - [x] Done item
      MD
      File.write(File.join(dir, "docs/CUSTOMER_FEEDBACK.md"), <<~MD)
        # Customer Feedback
        - Need CSV export for reports
        - Need CSV export for reports
      MD

      source = described_class.new(repo_root: dir)
      proposals = source.proposals(limit: 10)

      expect(proposals.map(&:title)).to include("Roadmap: Add export endpoint")
      expect(proposals.map(&:title)).to include("Customer feedback: Need CSV export for reports")
      expect(proposals.length).to eq(2)
    end
  end

  it "returns empty when source docs are missing" do
    Dir.mktmpdir do |dir|
      source = described_class.new(repo_root: dir)
      expect(source.proposals(limit: 10)).to eq([])
    end
  end
end
