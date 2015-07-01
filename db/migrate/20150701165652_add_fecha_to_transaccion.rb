class AddFechaToTransaccion < ActiveRecord::Migration
  def change
    add_column :transaccions, :fecha, :date
  end
end
