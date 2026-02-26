# frozen_string_literal: true

module GithubAgent
  class CommentCommand
    WAKE_WORDS = [ "@auto-codex", "/auto-codex", "@findandrew-bot" ].freeze
    TRUSTED_ASSOCIATIONS = %w[OWNER MEMBER COLLABORATOR].freeze

    Result = Data.define(
      :should_run,
      :authorized,
      :wake_word,
      :command,
      :reason,
      :pr_number,
      :comment_id,
      :commenter,
      :association
    )

    def self.from_event(event)
      body = event.dig("comment", "body").to_s
      wake_word, command = parse_command(body)

      pr_number = extract_pr_number(event)
      comment_id = event.dig("comment", "id")
      commenter = event.dig("comment", "user", "login").to_s
      association = event.dig("comment", "author_association").to_s.upcase
      authorized = TRUSTED_ASSOCIATIONS.include?(association)

      reason = if pr_number.nil?
        "not_pr_comment"
      elsif wake_word.nil?
        "missing_wake_word"
      elsif !authorized
        "unauthorized_association"
      else
        "ok"
      end

      Result.new(
        should_run: reason == "ok",
        authorized: authorized,
        wake_word: wake_word,
        command: command.to_s.strip,
        reason: reason,
        pr_number: pr_number,
        comment_id: comment_id,
        commenter: commenter,
        association: association
      )
    end

    def self.parse_command(body)
      return [ nil, nil ] if body.to_s.strip.empty?

      match = body.match(/(?:^|\s)(@auto-codex|\/auto-codex|@findandrew-bot)\b/i)
      return [ nil, nil ] unless match

      wake_word = match[1].downcase
      command = body[match.end(0)..]&.strip
      command = "status" if command.nil? || command.empty?
      [ wake_word, command ]
    end

    def self.extract_pr_number(event)
      if event.key?("issue")
        return nil if event.dig("issue", "pull_request").nil?

        return event.dig("issue", "number")
      end

      event.dig("pull_request", "number")
    end

    private_class_method :parse_command
    private_class_method :extract_pr_number
  end
end
