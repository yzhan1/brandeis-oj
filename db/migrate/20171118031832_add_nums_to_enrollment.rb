class AddNumsToEnrollment < ActiveRecord::Migration[5.1]
  def change
    add_column :enrollments, :total, :float
    add_column :enrollments, :count, :float
  end
end
