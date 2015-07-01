class AddCantidadToFabricacion < ActiveRecord::Migration
  def change
    add_column :fabricacions, :cantidad, :integer
  end
end
