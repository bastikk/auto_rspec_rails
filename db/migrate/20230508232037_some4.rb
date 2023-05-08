class Some4 < ActiveRecord::Migration[7.0]
  change_table :test_models do |t|
    t.references :a
    t.references :b
  end
end
