class CreatePromoManagers < ActiveRecord::Migration
  def change
    create_table :promo_managers do |t|
      t.string :sku
      t.string :precio
      t.string :codigo

      t.timestamps null: false
    end
  end
end
