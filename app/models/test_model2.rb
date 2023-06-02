# frozen_string_literal: true
class TestModel2
  include ActiveModel::Model

  attr_accessor :some

  validates_presence_of :some
end