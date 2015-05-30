class AddOcToPedidos < ActiveRecord::Migration
  def change
    add_column :pedidos, :order_id, :string
  end
end
