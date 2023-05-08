class Some < ActiveRecord::Migration[7.0]
  def change
    change_table :cs do |t|
      t.references :test_models, null: false, foreign_key: true
    end
  end
end
