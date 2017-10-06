class ChangeCourseCodeFromIntegerToString < ActiveRecord::Migration[5.1]
  def change
    change_column :assignments, :course_code, :string
    change_column :courses, :course_code, :string
    change_column :enrollments, :course_code, :string
  end
end
