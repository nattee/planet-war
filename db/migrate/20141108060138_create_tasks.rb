class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :type
      t.references :params
      t.integer :state
      t.datetime :finished_at

      t.timestamps
    end
    add_index :tasks, :params_id
  end
end
