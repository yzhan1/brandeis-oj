class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def landing
    render file: Rails.public_path.join('landing.html'), layout: true #'../assets/htmls/landing.html'
  end
end
