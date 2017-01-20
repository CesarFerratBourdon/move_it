class CreatePricings < ActiveRecord::Migration
  def change
    create_table :pricings do |t|
      t.integer :distance
      t.integer :volume_living
      t.integer :volume_basement
      t.boolean :piano

      t.timestamps
    end
  end
end
