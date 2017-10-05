class CreateProdEnrollments < ActiveRecord::Migration[5.1]
  def change
    create_table :prod_enrollments do |t|
      t.integer :student_id
      t.integer :course_id
      t.float :final_grade

      t.timestamps
    end
  end
end
