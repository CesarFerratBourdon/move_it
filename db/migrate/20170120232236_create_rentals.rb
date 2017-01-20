class CreateRentals < ActiveRecord::Migration
  def change
    create_table :rentals do |t|
      t.integer :number_of_cars
      t.integer :total_price
      t.references :user, index: true

      t.timestamps
    end
  end
end
