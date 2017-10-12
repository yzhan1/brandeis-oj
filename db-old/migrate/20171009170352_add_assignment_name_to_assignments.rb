class AddAssignmentNameToAssignments < ActiveRecord::Migration[5.1]
  def change
    add_column :assignments, :assignment_name, :string
  end
end
