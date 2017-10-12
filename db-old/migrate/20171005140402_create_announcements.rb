class CreateAnnouncements < ActiveRecord::Migration[5.1]
  def change
    create_table :announcements do |t|
      t.string :course_code
      t.datetime :announcement_date
      t.string :announcement_body
      t.string :announcement_link

      t.timestamps
    end
  end
end
