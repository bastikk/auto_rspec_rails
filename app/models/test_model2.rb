# frozen_string_literal: true
class TestModel2
  include ActiveModel::Model

  attr_accessor :some, :some2, :other, :another

  validates_presence_of :some, :other
  validates_presence_of :some2
  validates_absence_of :another
  validates_acceptance_of :some
  validates_confirmation_of :other
  validates_exclusion_of :some, in: ['foo', 'bar'], message: 'is reserved'
  validates_inclusion_of :other, in: [1, 2, 3]
  validates_length_of :some, minimum: 5, maximum: 10
  validates_numericality_of :other, greater_than: 0, less_than: 100
end