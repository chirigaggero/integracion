class CreateCompraB2Bs < ActiveRecord::Migration
  def change
    create_table :compra_b2_bs do |t|

      t.timestamps null: false
    end
  end
end
