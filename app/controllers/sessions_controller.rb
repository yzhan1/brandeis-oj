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

  def oauth_login
    @user = User.from_omniauth request.env['omniauth.auth']
    if @user.id
      log_in @user
      redirect_back_or dashboard_url
    else
      redirect_to root_path, flash: { error: 'Please log in with Brandeis Email' }
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
