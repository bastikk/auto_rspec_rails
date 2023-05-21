# frozen_string_literal: true
class SomeSerializer
  def self.dump(value)
    value.to_s
  end

  def self.load(value)
    value
  end
end

class ReadonlyTextSerializer
  def initialize
  end

  def dump(value)
    value.to_s
  end

  def load(value)
    value
  end
end


class TestModel < ApplicationRecord
  belongs_to :a
  # , -> { where(id: 1) }, polymorphic: true
  belongs_to :b

  has_one :c
  # accepts_nested_attributes_for :c, allow_destroy: true, update_only: true, limit: 3
  attr_accessor :some
  attr_readonly :readonly_text

  serialize :some, SomeSerializer
  serialize :readonly_text, ReadonlyTextSerializer.new

  validates :some, uniqueness: true
  # has_rich_text :some1
  #
  enum status: [:running, :stopped]
  enum status2: { suspended: 'suspended', other: 'other' }


  # todo fix issue with two values
  self.implicit_order_column = :created_at
  self.implicit_order_column = :updated_at

  # validates :dta_id, :calculated_result_id, presence: true
end