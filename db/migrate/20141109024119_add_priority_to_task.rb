class AddPriorityToTask < ActiveRecord::Migration
  def up
    add_column :tasks, :priority, :integer, default: 0
    change_column_default :tasks, :state, 0
    remove_column :tasks, :type
    remove_column :tasks, :params_id
    add_column :tasks, :match_id, :integer
  end

  def down
    remove_column :tasks, :priority
    change_column_default :tasks, :state, nil
    add_column :tasks, :type, :integer, default: 0
    add_column :tasks, :params_id, :integer
    remove_column :tasks, :match_id
  end
end
