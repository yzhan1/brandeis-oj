class RemoveTestIdFromCodes < ActiveRecord::Migration[5.1]
  def change
    remove_column :codes, :test_id, :integer
  end
end
