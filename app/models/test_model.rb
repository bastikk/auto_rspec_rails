# frozen_string_literal: true

class TestModel < ApplicationRecord
  belongs_to :a
  belongs_to :b

  has_one :c
  accepts_nested_attributes_for :c
  attr_accessor :some
  # has_rich_text :some1
  enum status: [:running, :stopped, :suspended]

  # validates :dta_id, :calculated_result_id, presence: true
end