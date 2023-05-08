class Some2 < ActiveRecord::Migration[7.0]
  change_table :cs do |t|
    t.references :test_models, null: false, foreign_key: true
  end

  change_table :test_models do |t|
    t.references :as, null: false, foreign_key: true
  end

  change_table :test_models do |t|
    t.references :bs, null: false, foreign_key: true
  end
end
