class RemoveOrderidFromPedidos < ActiveRecord::Migration
  def change
    remove_column :pedidos, :order_id, :integer
  end
end
