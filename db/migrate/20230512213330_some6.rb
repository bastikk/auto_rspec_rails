class Some6 < ActiveRecord::Migration[7.0]
  def change
    remove_index :test_models, :a_id
    add_index :test_models, :a_id, unique: true
  end
end
