class AddAutomatedGradeToSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :submissions, :auto_grade, :integer
  end
end
