class CreateOcManagers < ActiveRecord::Migration
  def change
    create_table :oc_managers do |t|

      t.timestamps null: false
    end
  end
end
