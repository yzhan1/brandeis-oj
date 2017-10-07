class RenameCourseIdToCourseCode < ActiveRecord::Migration[5.1]
  def change
    rename_column :assignments, :course_id, :course_code
    rename_column :enrollments, :course_id, :course_code
  end
end
