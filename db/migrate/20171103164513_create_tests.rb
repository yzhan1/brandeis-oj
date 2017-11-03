class CreateTests < ActiveRecord::Migration[5.1]
  def change
    create_table :tests do |t|
      #internal fields

      #external references
      t.integer :user_id
      t.integer :assignment_id

      t.timestamps
    end
  end
end
