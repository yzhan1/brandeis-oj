class AddPermissionToEnrollments < ActiveRecord::Migration[5.1]
  def change
    add_column :enrollments, :permission, :string
  end
end
