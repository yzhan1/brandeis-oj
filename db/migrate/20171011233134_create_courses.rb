class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      #internal fields
      t.string :course_title
      t.string :course_code

      #external references
      t.integer :user_id

      t.timestamps
    end
  end
end
