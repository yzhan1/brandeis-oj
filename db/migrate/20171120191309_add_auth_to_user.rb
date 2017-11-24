class AddAuthToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :oauth_provider, :string
    add_column :users, :oauth_uid, :string
    add_column :users, :oauth_name, :string
    add_column :users, :oauth_token, :string
    add_column :users, :oauth_expires_at, :datetime
  end
end
