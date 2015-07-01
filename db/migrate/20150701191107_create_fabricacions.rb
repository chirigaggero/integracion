class CreateFabricacions < ActiveRecord::Migration
  def change
    create_table :fabricacions do |t|
      t.date :fecha
      t.string :sku

      t.timestamps null: false
    end
  end
end
