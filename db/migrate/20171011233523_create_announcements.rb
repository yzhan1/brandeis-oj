class CreateAnnouncements < ActiveRecord::Migration[5.1]
  def change
    create_table :announcements do |t|
      #internal fields
      t.string :name
      t.datetime :announcement_date
      t.string :announcement_body

      #external references
      t.integer :course_id

      t.timestamps
    end
  end
end
