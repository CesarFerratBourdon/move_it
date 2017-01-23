class RentalsController < ApplicationController

  def new_rental
    rental = Rental.create(rental_params)
    current_user.rentals.push(rental)
          render :json => rental, status: 200
  end

  def calculate_pricing
    (distance_pricing * volume_pricing ) + piano_pricing
  end

  def list_rentals
    @rentals = current_user.rentals
  end

  private

    def distance_pricing
      distance = rental_params["distance"]/1000.to_i  #convert distance from m to km
      if distance < 50
        1000 + 10*(distance)
      elsif distance >= 50 && distance < 100
        5000 + 8*(distance)
      elsif distance >= 100
        10000 + 7*(distance)
      end
    end

    def volume_pricing
      volume_total = rental_params["size_living"].to_i + 2*(rental_params["size_basement"].to_i)
      number_of_cars = (volume_total/50).to_i + 1
      return number_of_cars
    end

    def piano_pricing
      if rental_params["piano"] == "yes"
        return 5000
      else
        return 0
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rental_params
      params.permit(:city1, :city2, :piano, :size_living, :size_basement, :distance)
    end

end
