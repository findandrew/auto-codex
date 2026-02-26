#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../../lib/github_agent/feedback_log"

pr_number = ENV.fetch("PR_NUMBER")
comment_id = ENV.fetch("COMMENT_ID")
commenter = ENV.fetch("COMMENTER")
wake_word = ENV.fetch("WAKE_WORD")
command = ENV.fetch("COMMAND")
event_name = ENV.fetch("EVENT_NAME")

log = GithubAgent::FeedbackLog.new
path = log.append(
  pr_number: pr_number,
  comment_id: comment_id,
  commenter: commenter,
  wake_word: wake_word,
  command: command,
  event_name: event_name
)

output_path = ENV["GITHUB_OUTPUT"]
if output_path && !output_path.empty?
  File.open(output_path, "a", encoding: "utf-8") { |f| f.puts "log_path=#{path}" }
else
  puts path
end
