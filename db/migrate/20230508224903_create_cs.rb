class CreateCs < ActiveRecord::Migration[7.0]
  def change
    create_table :cs do |t|
      t.string :title2
      t.text :body2

      t.timestamps
    end
  end
end
