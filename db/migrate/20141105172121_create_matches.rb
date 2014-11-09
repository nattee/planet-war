class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :p1_sub
      t.references :p2_sub
      t.integer :score1
      t.integer :score2
      t.string :map
      t.text :log
      t.datetime :play_at

      t.timestamps
    end
    add_index :matches, :p1_sub_id
    add_index :matches, :p2_sub_id
  end
end
