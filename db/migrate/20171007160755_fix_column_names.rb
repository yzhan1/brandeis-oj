class FixColumnNames < ActiveRecord::Migration[5.1]
  def change
    rename_column :courses, :teacher_id, :user_id
    rename_column :enrollments, :student_id, :user_id
    rename_column :submissions, :student_id, :user_id
  end
end
