module SessionsHelper

  def log_in(user, is_student)
    session[:user_id] = user.id
    session[:is_student] = is_student
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    if (user_id = session[:user_id])
      if session[:is_student]
        @current_user ||= Student.find_by(id: session[:user_id])
      else
        @current_user ||= Teacher.find_by(id: session[:user_id])
      end
    elsif (user_id = cookies.signed[:user_id])
      user = nil
      if session[:is_student]
        user = Student.find_by(id: user_id)
      else
        user = Teacher.find_by(id: user_id)
      end
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def is_student?
    if session[:is_student]
      true
    else
      false
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    session.delete(:is_student)
    @current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
