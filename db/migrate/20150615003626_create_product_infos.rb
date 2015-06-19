class CreateProductInfos < ActiveRecord::Migration
  def change
    create_table :product_infos do |t|
      t.string :nombre
      t.string :descripcion
      t.string :img
      t.decimal :precio

      t.timestamps null: false
    end
  end
end
