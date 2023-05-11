# frozen_string_literal: true
# todo remove it
# make include somewhere else and add it to description
require 'rails_helper'

RSpec.describe TestModel, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:a) }
    it { is_expected.to belong_to(:b) }
    it { is_expected.to have_one(:c) }
  end

  it do
    is_expected.to define_enum_for(:status)
      .with_values({"running"=>0, "stopped"=>1})
  end
  it do
    is_expected.to define_enum_for(:status2)
      .with_values({"suspended"=>"suspended", "other"=>"other"})
      '.backed_by_column_of_type(:string)' if enum_details.values.any? { _1.is_a?(String) }
  end
end