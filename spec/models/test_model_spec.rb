# frozen_string_literal: true

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
      .backed_by_column_of_type(:string)
  end

    it { is_expected.to have_db_column(:cs_id) }
    it { is_expected.to have_db_column(:as_id) }
    it { is_expected.to have_db_column(:bs_id) }
    it { is_expected.to have_db_column(:a_id) }
    it { is_expected.to have_db_column(:b_id) }
    it { is_expected.to have_db_column(:some) }
    it { is_expected.to have_db_column(:status) }
    it { is_expected.to have_db_column(:status2) }
    it { is_expected.to have_db_column(:readonly_text) }

    it { is_expected.to have_db_index(:a_id).unique }
    it { is_expected.to have_db_index(:b_id) }
    it { is_expected.to have_db_index(:bs_id) }
    it { is_expected.to have_db_index(:as_id) }
    it { is_expected.to have_db_index(:cs_id) }

    it { is_expected.to have_implicit_order_column(:updated_at) }

    it { is_expected.to have_readonly_attribute(:readonly_text) }
end