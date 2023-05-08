# frozen_string_literal: true

RSpec.describe TestModel, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:author) }
    it { is_expected.to belong_to(:dta) }
    it { is_expected.to have_one(:book) }
  end
end