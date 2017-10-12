class CreateAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :assignments do |t|
      #internal fields
      t.string :name
      t.datetime :due_date
      t.string :instructions
      t.string :template

      #external references
      t.integer :course_id

      t.timestamps
    end
  end
end
