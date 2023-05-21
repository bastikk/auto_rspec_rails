class Some8 < ActiveRecord::Migration[7.0]
  def change
    remove_column :test_models, :status2
    add_column :test_models, :status2, :string
  end
end
