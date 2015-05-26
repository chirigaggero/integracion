class RemoveFechaFromPedidos < ActiveRecord::Migration
  def change
    remove_column :pedidos, :fechaEntrega, :datetime
  end
end
