class CreateBancos < ActiveRecord::Migration
  def change
    create_table :bancos do |t|

      t.timestamps null: false
    end
  end
end
