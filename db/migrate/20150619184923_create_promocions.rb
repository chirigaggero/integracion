class CreatePromocions < ActiveRecord::Migration
  def change
    create_table :promocions do |t|
      t.string :sku
      t.string :precio
      t.string :codigo

      t.timestamps null: false
    end
  end
end
