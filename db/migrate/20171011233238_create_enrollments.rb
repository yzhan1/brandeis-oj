class CreateEnrollments < ActiveRecord::Migration[5.1]
  def change
    create_table :enrollments do |t|
      #internal fields
      t.float :final_grade

      #external references
      t.integer :course_id
      t.integer :user_id

      t.timestamps
    end
  end
end
