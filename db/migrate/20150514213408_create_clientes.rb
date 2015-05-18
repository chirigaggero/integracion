class CreateClientes < ActiveRecord::Migration
  def change
    create_table :clientes do |t|
      t.integer :cliente_id
      t.string :nombre
      t.string :direccion

      t.timestamps null: false
    end
  end
end
