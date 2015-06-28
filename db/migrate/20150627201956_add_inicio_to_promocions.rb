class AddInicioToPromocions < ActiveRecord::Migration
  def change
    add_column :promocions, :inicio, :date
    add_column :promocions, :fin, :date
  end
end
