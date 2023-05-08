class CreateDs < ActiveRecord::Migration[7.0]
  def change
    create_table :ds do |t|
      t.string :title3
      t.text :body3

      t.timestamps
    end
  end
end
