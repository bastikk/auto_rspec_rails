class Some9 < ActiveRecord::Migration[7.0]
  def change
    add_column :test_models, :readonly_text, :string
  end
end
