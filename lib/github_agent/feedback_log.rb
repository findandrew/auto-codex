# frozen_string_literal: true

require "fileutils"
require "time"

module GithubAgent
  class FeedbackLog
    def initialize(repo_root: Dir.pwd)
      @repo_root = repo_root
    end

    def append(pr_number:, comment_id:, commenter:, wake_word:, command:, event_name:)
      FileUtils.mkdir_p(File.dirname(log_path(pr_number)))

      entry = [
        "## #{Time.now.utc.iso8601}",
        "- Event: #{event_name}",
        "- Comment ID: #{comment_id}",
        "- Requested by: @#{commenter}",
        "- Wake word: #{wake_word}",
        "- Command: #{command}",
        ""
      ].join("\n")

      File.open(log_path(pr_number), "a", encoding: "utf-8") { |f| f << entry }
      log_path(pr_number)
    end

    private

    attr_reader :repo_root

    def log_path(pr_number)
      File.join(repo_root, "docs/agent_runs/pr-#{pr_number}.md")
    end
  end
end
