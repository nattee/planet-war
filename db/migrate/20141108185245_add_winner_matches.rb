class AddWinnerMatches < ActiveRecord::Migration
  def up
    add_column :matches, :winner, :integer
    remove_column :matches, :score1
    remove_column :matches, :score2
  end

  def down
    remove_column :matches, :winner
    add_column :matches, :score1, :integer
    add_column :matches, :score2, :integer

  end
end
