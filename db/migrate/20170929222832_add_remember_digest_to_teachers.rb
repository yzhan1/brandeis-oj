class AddRememberDigestToTeachers < ActiveRecord::Migration[5.1]
  def change
    add_column :teachers, :remember_digest, :string
  end
end
