class AddColumnsToRental < ActiveRecord::Migration
  def change
    add_column :rentals, :distance, :integer
    add_column :rentals, :size_living, :integer
    add_column :rentals, :size_basement, :integer
    add_column :rentals, :piano, :string
    add_column :rentals, :city1, :string
    add_column :rentals, :city2, :string
  end
end
