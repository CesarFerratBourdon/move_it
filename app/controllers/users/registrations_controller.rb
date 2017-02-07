class Users::RegistrationsController < Devise::RegistrationsController
  include ApplicationHelper

  def create
    super
  end

  def new
    super
  end

  def edit
    super
  end


protected


  def after_sign_up_path_for(resource)
     dashboard_path
  end

end
