class AddFechaCantdToPedidos < ActiveRecord::Migration
  def change
    add_column :pedidos, :fechaEntrega, :datetime
    add_column :pedidos, :cantidadDespachada, :integer
    add_column :pedidos, :estado, :string
  end
end
