# frozen_string_literal: true

class TestModel < ApplicationRecord
  belongs_to :author
  belongs_to :dta

  has_one :book

  validates :dta_id, :calculated_result_id, presence: true
end