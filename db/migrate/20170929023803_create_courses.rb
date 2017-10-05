class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :course_title
      t.integer :teacher_id
      t.string :course_code

      t.timestamps
    end
  end
end
