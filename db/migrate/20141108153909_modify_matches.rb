class ModifyMatches < ActiveRecord::Migration

  def up
    change_table :matches do |t|
      t.change :log, :mediumtext 
    end
  end

  def down
    change_table :matches do |t|
      t.change :log, :text
    end
  end
end
