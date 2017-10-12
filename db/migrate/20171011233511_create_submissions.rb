class CreateSubmissions < ActiveRecord::Migration[5.1]
  def change
    create_table :submissions do |t|
      #internal fields
      t.boolean :submitted
      t.datetime :submission_date
      t.string :source_code
      t.float :grade

      #external references
      t.integer :user_id
      t.integer :assignment_id

      t.timestamps
    end
  end
end
