class AddEcommerceToPedido < ActiveRecord::Migration
  def change
    add_column :pedidos, :ecommerce, :boolean
  end
end
