class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :token
      t.datetime :token_expires_at

      t.timestamps null: false
    end
    add_index :users, ["username"], name: "index_users_on_username", unique: true
    add_index :users, ["token"], name: "index_users_on_access_token", unique: true
  end
end
