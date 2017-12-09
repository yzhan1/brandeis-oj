class AddNumAutomatedTestsToAssignment < ActiveRecord::Migration[5.1]
  def change
    add_column :assignments, :num_unit_tests, :integer
  end
end
