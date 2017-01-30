class RentalsController < ApplicationController


  def new_rental
    @user = current_user
    gon.id = @user.id
    rental = Rental.create(rental_params)
    current_user.rentals.push(rental)
          render :json => rental, status: 200
  end

  def calculate_pricing
    # @user = current_user
    # gon.id = @user.id
    quote = {}
    quote[:city1] = rental_params["city1"]
    quote[:city2] = rental_params["city2"]
    quote[:distance] = ((rental_params["distance"].to_f)/1000).round  #convert distance from m to km
    quote[:size_living] = rental_params["size_living"]
    quote[:size_basement] = rental_params["size_basement"]
    quote[:piano] = rental_params["piano"]
    quote[:total_price] = (distance_pricing * volume_pricing ) + piano_pricing
    quote[:number_of_cars] = volume_pricing

    render :json => quote , status: 200
  end


  # private

    def distance_pricing
      distance = ((rental_params["distance"].to_f)/1000).round
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
      params.permit(:city1, :city2, :piano, :size_living, :size_basement, :distance, :total_price, :number_of_cars)
    end

end
