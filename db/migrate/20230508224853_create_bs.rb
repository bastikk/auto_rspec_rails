class CreateBs < ActiveRecord::Migration[7.0]
  def change
    create_table :bs do |t|
      t.string :title1
      t.text :body1

      t.timestamps
    end
  end
end
