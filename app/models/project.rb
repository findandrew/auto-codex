class Project < ApplicationRecord
  STATUSES = %w[planned active archived].freeze

  validates :name, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
end
