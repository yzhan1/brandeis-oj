class CreateAnnouncements < ActiveRecord::Migration[5.1]
  def change
    create_table :announcements do |t|
      #internal fields
      t.datetime :announcement_date
      t.string :announcement_body
      t.string :announcement_link

      #external references
      t.string :course_code

      t.timestamps
    end
  end
end
