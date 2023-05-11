# frozen_string_literal: true

class TestModel < ApplicationRecord
  belongs_to :a
  # , -> { where(id: 1) }, polymorphic: true
  belongs_to :b

  has_one :c
  # accepts_nested_attributes_for :c, allow_destroy: true, update_only: true, limit: 3
  attr_accessor :some
  # has_rich_text :some1
  # todo prefix not implemented
  enum status: [:running, :stopped], _prefix: :old
  enum status2: { suspended: 'suspended', other: 'other' }

  # validates :dta_id, :calculated_result_id, presence: true
end