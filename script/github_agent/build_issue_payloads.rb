#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require_relative "../../lib/github_agent/issue_proposal_source"

output_file = ARGV[0] || "tmp/issue_proposals.json"
limit = (ARGV[1] || "10").to_i

source = GithubAgent::IssueProposalSource.new
payloads = source.proposals(limit: limit).map do |proposal|
  {
    "title" => proposal.title,
    "body" => proposal.body,
    "labels" => proposal.labels
  }
end

File.write(output_file, JSON.pretty_generate(payloads))
puts output_file
