class AddWeasToBodegas < ActiveRecord::Migration

  def change
    add_column :bodegas, :almacen_id, :string
    add_column :bodegas, :tipo, :string
  end

end
