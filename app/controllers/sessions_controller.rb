class SessionsController < ApplicationController
  def new
  end

  def create
    user = nil
    email = params[:session][:email].downcase
    # check if user is student or teacher
    if Student.exists?(email: email)
      user = Student.find_by(email: email)
    else
      user = Teacher.find_by(email: email)
    end

    if user && user.authenticate(params[:session][:password])      
      if user.is_a?(Student)
        # render student dashboard
        log_in user, true
        redirect_to stdn_dashboard_url
      else
        # render teacher dashboard
        log_in user, false
        redirect_to ta_dashboard_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
