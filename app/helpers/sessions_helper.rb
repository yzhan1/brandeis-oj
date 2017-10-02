module SessionsHelper

  def log_in(user, is_student)
    session[:user_id] = user.id
    session[:is_student] = is_student
  end

  def current_user
    @current_user = nil
    if session[:is_student]
      @current_user ||= Student.find_by(id: session[:user_id])
    else
      @current_user ||= Teacher.find_by(id: session[:user_id])
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

  def log_out
    session.delete(:user_id)
    session.delete(:is_student)
    @current_user = nil
  end
end
