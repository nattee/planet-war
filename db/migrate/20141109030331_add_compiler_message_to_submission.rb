class AddCompilerMessageToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :compiler_message, :text
    add_column :matches, :state, :integer, default: 0
  end
end
