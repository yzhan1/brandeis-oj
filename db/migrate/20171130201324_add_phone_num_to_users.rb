class AddPhoneNumToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :phone, :integer
  end
end
