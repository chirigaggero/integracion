class AddFtpToPedidos < ActiveRecord::Migration
  def change
    add_column :pedidos, :ftp, :boolean
  end
end
