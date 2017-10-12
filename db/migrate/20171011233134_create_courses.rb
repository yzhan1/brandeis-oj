class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      #internal fields
      t.string :course_title
      t.string :course_code
      t.string :permission

      t.timestamps
    end
  end
end
