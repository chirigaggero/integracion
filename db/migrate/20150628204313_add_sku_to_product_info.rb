class AddSkuToProductInfo < ActiveRecord::Migration
  def change
    add_column :product_infos, :sku, :integer
  end
end
