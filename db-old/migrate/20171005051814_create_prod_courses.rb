class CreateProdCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :prod_courses do |t|
      t.string :course_title
      t.integer :teacher_id
      t.integer :course_code

      t.timestamps
    end
  end
end
