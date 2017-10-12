class CreateEnrollments < ActiveRecord::Migration[5.1]
  def change
    create_table :enrollments do |t|
      #internal fields
      t.float :final_grade
      t.string :permission

      #external references
      t.string :course_code
      t.integer :user_id

      t.timestamps
    end
  end
end
