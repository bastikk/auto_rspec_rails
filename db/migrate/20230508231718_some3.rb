class Some3 < ActiveRecord::Migration[7.0]
  change_table :cs do |t|
    t.references :test_model
  end
end
