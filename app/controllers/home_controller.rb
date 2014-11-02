class HomeController < ApplicationController
  def index
    @info = request.env["omniauth.auth"]
  end
end
