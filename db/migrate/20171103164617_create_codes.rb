class CreateCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :codes do |t|
      #internal fields
      t.string :user_code
      t.string :directory
      t.string :filename

      #external references
      t.integer :test_id
      t.integer :submission_id

      t.timestamps
    end

  end
end
