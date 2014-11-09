class AddCompilerMessageToSubmission < ActiveRecord::Migration
  def up
    change_table :submissions do |t|
      t.text "compiler_message"
    end

    change_table :matches do |t|
      t.integer    "state", default: 0
      t.integer    "match_type", default: 0
      t.remove     "map"
      t.references "map"
    end
  end

  def down
    change_table :submissions do |t|
      t.remove "compiler_message"
    end

    change_table :matches do |t|
      t.remove    "state"
      t.remove    "match_type"
      t.remove    "map_id"
      t.string    "map"
    end
  end
end
