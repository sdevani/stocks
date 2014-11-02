class SessionsController < ApplicationController
  def create
    user = User.get_omniauth_user(omniauth_params: request.env["omniauth.auth"])
    if user.nil?
      redirect_to "/", notice: "Could not log in"
    else
      session[:user_id] = user.id
      redirect_to "/", notice: "Logged in #{user.id}"
    end
  end
end
