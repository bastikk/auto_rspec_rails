# frozen_string_literal: true
class TestModel < ApplicationRecord
  belongs_to :a
  belongs_to :b

  has_one :c
  attr_accessor :some
  attr_readonly :readonly_text

  validates :some, uniqueness: true
  enum status: [:running, :stopped]
  enum status2: { suspended: 'suspended', other: 'other' }

  self.implicit_order_column = :created_at
  self.implicit_order_column = :updated_at
end