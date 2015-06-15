class AddProductIdToProductInfo < ActiveRecord::Migration
  def change
    add_column :product_infos, :product_id, :string
  end
end
