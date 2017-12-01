class RemoveDirectoryFromCodes < ActiveRecord::Migration[5.1]
  def change
    remove_column :codes, :directory, :string
  end
end
