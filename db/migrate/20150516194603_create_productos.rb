class CreateProductos < ActiveRecord::Migration
  def change
    create_table :productos do |t|
      t.string :prod_id

      t.timestamps null: false
    end
  end
end
