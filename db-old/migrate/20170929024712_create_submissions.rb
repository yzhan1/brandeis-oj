class CreateSubmissions < ActiveRecord::Migration[5.1]
  def change
    create_table :submissions do |t|
      t.boolean :submitted
      t.integer :student_id
      t.integer :assignment_id
      t.datetime :submission_date
      t.text :source_code
      t.float :grade

      t.timestamps
    end
  end
end
