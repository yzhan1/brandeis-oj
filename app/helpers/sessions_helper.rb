module SessionsHelper
  def log_in user
    session[:user_id] = user.id
    session[:is_student] = user.role == 'student'
    cookies.signed[:actioncable_user_id] = user.id
  end

  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def is_student?
    session[:is_student]
  end

  def logged_in_redirect
    redirect_to dashboard_url if logged_in?
  end

  def logged_in?
    !current_user.nil?
  end

  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  def log_out
    forget current_user
    session.delete :user_id
    session.delete :is_student
    cookies.delete :actioncable_user_id
    @current_user = nil
  end

  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete :forwarding_url
  end
  
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
