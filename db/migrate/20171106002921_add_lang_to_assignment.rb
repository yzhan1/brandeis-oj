class AddLangToAssignment < ActiveRecord::Migration[5.1]
  def change
    add_column :assignments, :lang, :string
  end
end
