class HomesController < ApplicationController
  def index
    @user = current_user
    if user_signed_in?
      redirect_to dashboard_path(@user)
    end
  end
end
