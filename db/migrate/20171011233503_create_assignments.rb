class CreateAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :assignments do |t|
      #internal fields
      t.string :assignment_name
      t.datetime :due_date
      t.text :instructions
      t.string :template

      #external references
      t.string :course_code
      
      t.timestamps
    end
  end
end
