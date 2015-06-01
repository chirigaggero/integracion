class CreateFtpManagers < ActiveRecord::Migration
  def change
    create_table :ftp_managers do |t|

      t.timestamps null: false
    end
  end
end
