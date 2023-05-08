class Some1 < ActiveRecord::Migration[7.0]
  change_table :bs do |t|
    t.references :test_models, null: false, foreign_key: true
  end

  change_table :test_models do |t|
    t.references :cs, null: false, foreign_key: true
  end
end
