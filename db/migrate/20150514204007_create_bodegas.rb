class CreateBodegas < ActiveRecord::Migration
  def change
    create_table :bodegas do |t|

      t.timestamps null: false
    end
  end
end
