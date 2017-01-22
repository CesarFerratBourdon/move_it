class UsersController < ApplicationController


  def show
    @rentals = current_user.rentals
  end

  def create_rental

  end

  def quote
    @user = current_user
  end

end
