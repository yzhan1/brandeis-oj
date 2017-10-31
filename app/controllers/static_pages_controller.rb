class StaticPagesController < ApplicationController
  def home
    if logged_in?
      redirect_to dashboard_url
    end
  end
end
