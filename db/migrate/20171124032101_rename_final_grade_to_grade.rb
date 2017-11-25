class RenameFinalGradeToGrade < ActiveRecord::Migration[5.1]
  def change
    rename_column :enrollments, :final_grade, :grade
  end
end
