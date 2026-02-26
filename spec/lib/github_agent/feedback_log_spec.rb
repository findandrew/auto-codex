# frozen_string_literal: true

require "rails_helper"
require "tmpdir"
require_relative "../../../lib/github_agent/feedback_log"

RSpec.describe GithubAgent::FeedbackLog do
  it "appends feedback entries to the PR run log" do
    Dir.mktmpdir do |dir|
      logger = described_class.new(repo_root: dir)
      path = logger.append(
        pr_number: 12,
        comment_id: 34,
        commenter: "findandrew",
        wake_word: "@auto-codex",
        command: "status",
        event_name: "issue_comment"
      )

      expect(path).to end_with("docs/agent_runs/pr-12.md")
      content = File.read(path)
      expect(content).to include("Comment ID: 34")
      expect(content).to include("Requested by: @findandrew")
      expect(content).to include("Command: status")
    end
  end
end
