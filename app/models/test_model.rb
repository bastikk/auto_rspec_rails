# frozen_string_literal: true

class TestModel < ApplicationRecord
  belongs_to :a
  belongs_to :b

  has_one :c

  # validates :dta_id, :calculated_result_id, presence: true
end