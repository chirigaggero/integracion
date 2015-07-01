class CreateTransaccions < ActiveRecord::Migration
  def change
    create_table :transaccions do |t|
      t.string :monto
      t.string :destino

      t.timestamps null: false
    end
  end
end
