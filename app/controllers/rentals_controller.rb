class RentalsController < ApplicationController

  def form
  end

  def new_rental
    p params
    rental = Rental.create(rental_params)
    current_user.rentals.push(rental)
          render :json => rental, status: 200
  end

  def list_rentals
    @rentals = current_user.rentals
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def rental_params
      params.permit(:city1, :country1, :city2, :country2, :lat1, :lng1, :lat2, :lng2, :id, :piano, :size_living, :size_basement, :distance)
    end

end
