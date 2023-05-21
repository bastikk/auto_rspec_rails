class Some7 < ActiveRecord::Migration[7.0]
  def change
    add_column :test_models, :status, :integer
    add_column :test_models, :status2, :integer
  end
end
