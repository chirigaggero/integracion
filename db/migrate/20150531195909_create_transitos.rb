class CreateTransitos < ActiveRecord::Migration
  def change
    create_table :transitos do |t|
      t.boolean :azucar, :default => false
      t.boolean :madera, :default => false
      t.boolean :celulosa, :default => false
      t.boolean :chocolate, :default => false
      t.boolean :pasta_semola, :default => false
      t.boolean :semola, :default => false
      t.boolean :sal, :default => false
      t.boolean :huevo, :default => false
      t.boolean :cacao, :default => false
      t.boolean :leche, :default => false

      t.timestamps null: false
    end
  end
end
