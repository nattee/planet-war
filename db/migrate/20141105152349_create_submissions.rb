class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.references :user
      t.datetime :submitted
      t.references :language
      t.text :code

      t.timestamps
    end
  end
end
