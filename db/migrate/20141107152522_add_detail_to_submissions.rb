class AddDetailToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :state, :integer, default: 0
    add_column :submissions, :ip_address, :string
    add_column :submissions, :filename, :string
    remove_column :submissions, :submitted
  end
end
