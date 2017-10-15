class SessionsController < ApplicationController
  def new
    logged_in_redirect
  end

  def create
    user = nil
    email = params[:session][:email].downcase
    # check if user exists
    if User.exists?(email: email)
      user = User.find_by(email: email)
    end

    if user && user.authenticate(params[:session][:password])      
      # render student dashboard
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to dashboard_url
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
