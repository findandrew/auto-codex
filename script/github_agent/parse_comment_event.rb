#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require_relative "../../lib/github_agent/comment_command"

output_path = ENV["GITHUB_OUTPUT"]
event_path = ENV["GITHUB_EVENT_PATH"]

abort "GITHUB_EVENT_PATH is required" if event_path.to_s.empty?

raw_event = File.read(event_path)
event = JSON.parse(raw_event)
result = GithubAgent::CommentCommand.from_event(event)

outputs = {
  "should_run" => result.should_run,
  "authorized" => result.authorized,
  "wake_word" => result.wake_word.to_s,
  "command" => result.command.to_s,
  "reason" => result.reason.to_s,
  "pr_number" => result.pr_number.to_s,
  "comment_id" => result.comment_id.to_s,
  "commenter" => result.commenter.to_s,
  "association" => result.association.to_s
}

if output_path && !output_path.empty?
  File.open(output_path, "a", encoding: "utf-8") do |f|
    outputs.each do |k, v|
      f.puts "#{k}=#{v}"
    end
  end
else
  puts JSON.pretty_generate(outputs)
end
