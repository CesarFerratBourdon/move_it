class RentalsController < ApplicationController

  def form
  end

  def new_rental
    rental = Rental.create(rental_params)
    current_user.rentals.push(rental)
  end

  def list_rentals
    @rentals = current_user.rentals
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def rental_params
      params.permit(:origin, :destination, :city1, :country1, :city2, :country2, :lat1, :lng1, :lat2, :lng2, :user_id, :piano, :size_living, :size_basement)
    end

end
