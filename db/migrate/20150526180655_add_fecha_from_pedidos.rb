class AddFechaFromPedidos < ActiveRecord::Migration
  def change
    add_column :pedidos, :fechaEntrega, :string
  end
end
