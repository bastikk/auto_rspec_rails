# frozen_string_literal: true
# todo remove it
require 'rails_helper'

RSpec.describe TestModel, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:a) }
    it { is_expected.to belong_to(:b) }
    it { is_expected.to have_one(:c) }
  end
end