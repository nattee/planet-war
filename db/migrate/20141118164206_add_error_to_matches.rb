class AddErrorToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :p1_err, :string
    add_column :matches, :p2_err, :string
  end
end
