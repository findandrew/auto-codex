# frozen_string_literal: true

module GithubAgent
  class IssueProposalSource
    Proposal = Data.define(:title, :body, :labels)

    ROADMAP_PATH = "docs/ROADMAP.md"
    CUSTOMER_FEEDBACK_PATH = "docs/CUSTOMER_FEEDBACK.md"

    def initialize(repo_root: Dir.pwd)
      @repo_root = repo_root
    end

    def proposals(limit: 10)
      items = []
      items.concat(extract_roadmap_items)
      items.concat(extract_feedback_items)

      deduped = {}
      items.each do |proposal|
        normalized = normalize_title(proposal.title)
        deduped[normalized] ||= proposal
      end

      deduped.values.first(limit)
    end

    private

    attr_reader :repo_root

    def extract_roadmap_items
      path = File.join(repo_root, ROADMAP_PATH)
      return [] unless File.exist?(path)

      section_lines(path, "## Candidate Items").filter_map do |line|
        next unless (match = line.match(/^\s*- \[ \] (.+)$/))

        summary = match[1].strip
        Proposal.new(
          title: "Roadmap: #{truncate(summary)}",
          body: "Automatically proposed from #{ROADMAP_PATH}.\n\n- Source item: #{summary}\n- Requested by: roadmap backlog",
          labels: %w[proposal roadmap]
        )
      end
    end

    def extract_feedback_items
      path = File.join(repo_root, CUSTOMER_FEEDBACK_PATH)
      return [] unless File.exist?(path)

      section_lines(path, "## Signals").filter_map do |line|
        next unless (match = line.match(/^\s*- (.+)$/))

        summary = match[1].strip
        next if summary.start_with?("[")

        Proposal.new(
          title: "Customer feedback: #{truncate(summary)}",
          body: "Automatically proposed from #{CUSTOMER_FEEDBACK_PATH}.\n\n- Feedback signal: #{summary}\n- Requested by: customer feedback backlog",
          labels: %w[proposal customer-feedback]
        )
      end
    end

    def truncate(text, max: 90)
      return text if text.length <= max

      "#{text[0, max - 1]}..."
    end

    def normalize_title(title)
      title.downcase.gsub(/\s+/, " ").strip
    end

    def section_lines(path, heading)
      lines = File.readlines(path, chomp: true)
      start_idx = lines.index(heading)
      return [] unless start_idx

      lines[(start_idx + 1)..].take_while { |line| !line.start_with?("## ") }
    end
  end
end
