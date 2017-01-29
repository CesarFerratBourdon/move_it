class HomesController < ApplicationController
  def index
    if current_user
      @user = current_user
      gon.id = @user.id
    end
    # if user_signed_in?
    #   redirect_to dashboard_path(@user)
    # end
  end
end
