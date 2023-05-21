class Some5 < ActiveRecord::Migration[7.0]
  def change
    add_column :test_models, :some, :string
  end
end
