class CreateProdAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :prod_assignments do |t|
      t.datetime :due_date
      t.integer :course_id
      t.text :instructions
      t.string :template
      
      t.timestamps
    end
  end
end
