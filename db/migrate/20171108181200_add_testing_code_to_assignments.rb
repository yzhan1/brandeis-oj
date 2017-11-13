class AddTestingCodeToAssignments < ActiveRecord::Migration[5.1]
  def change
    add_column :assignments, :test_code, :string
  end
end
