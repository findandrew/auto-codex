# frozen_string_literal: true

require "rails_helper"
require_relative "../../../lib/github_agent/comment_command"

RSpec.describe GithubAgent::CommentCommand do
  describe ".from_event" do
    let(:base_event) do
      {
        "issue" => { "number" => 42, "pull_request" => { "url" => "https://api.github.com/repos/org/repo/pulls/42" } },
        "comment" => {
          "id" => 99,
          "body" => "@auto-codex please update the spec",
          "author_association" => "OWNER",
          "user" => { "login" => "findandrew" }
        }
      }
    end

    it "accepts trusted wake-word comment on a PR" do
      result = described_class.from_event(base_event)

      expect(result.should_run).to be(true)
      expect(result.reason).to eq("ok")
      expect(result.command).to eq("please update the spec")
      expect(result.pr_number).to eq(42)
    end

    it "rejects non-wake-word comments" do
      event = Marshal.load(Marshal.dump(base_event))
      event["comment"]["body"] = "please update the spec"

      result = described_class.from_event(event)

      expect(result.should_run).to be(false)
      expect(result.reason).to eq("missing_wake_word")
    end

    it "rejects non-PR issue comments" do
      event = Marshal.load(Marshal.dump(base_event))
      event["issue"].delete("pull_request")

      result = described_class.from_event(event)

      expect(result.should_run).to be(false)
      expect(result.reason).to eq("not_pr_comment")
    end

    it "rejects untrusted associations" do
      event = Marshal.load(Marshal.dump(base_event))
      event["comment"]["author_association"] = "CONTRIBUTOR"

      result = described_class.from_event(event)

      expect(result.should_run).to be(false)
      expect(result.reason).to eq("unauthorized_association")
    end

    it "defaults empty command to status" do
      event = Marshal.load(Marshal.dump(base_event))
      event["comment"]["body"] = "@auto-codex"

      result = described_class.from_event(event)

      expect(result.should_run).to be(true)
      expect(result.command).to eq("status")
    end
  end
end
