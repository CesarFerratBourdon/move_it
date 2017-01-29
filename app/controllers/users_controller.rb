class UsersController < ApplicationController


  def show
    @user = current_user
    gon.id = @user.id
    @rentals = current_user.rentals
  end


end
