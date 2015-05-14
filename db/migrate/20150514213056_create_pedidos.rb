class CreatePedidos < ActiveRecord::Migration
  def change
    create_table :pedidos do |t|
      t.integer :order_id
      t.string :sku
      t.integer :cantidad
      t.decimal :precio_unitario
      t.string :direccion

      t.timestamps null: false
    end
  end
end
