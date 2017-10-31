class SessionsController < ApplicationController
  def new
    logged_in_redirect
  end

  def create
    email = params[:session][:email].downcase
    user = User.exists?(email: email) ? User.find_by(email: email) : nil
    if user && user.authenticate(params[:session][:password])
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
