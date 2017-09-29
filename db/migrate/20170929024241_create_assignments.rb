class CreateAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :assignments do |t|
      t.datetime :due_date
      t.integer :course_id
      t.text :instructions
      t.string :template

      t.timestamps
    end
  end
end
