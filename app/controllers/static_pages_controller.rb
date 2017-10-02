class StaticPagesController < ApplicationController
  def home
  end

  def about
  end

  def contact
  end

  def demo
  end

  def login
  end

  def assignment_editor

  end

  def submission_editor

  end

  def assignments_list

  end

  def ta_dashboard
    @user = Teacher.find(session[:user_id])
  end

  def stdn_dashboard
    @course_list = Course.pluck(:course_title).zip Course.pluck(:course_code)
    @assignment_list = Submission.pluck(:submitted).zip Submission.pluck(:assignment_id), Assignment.pluck(:due_date), Assignment.pluck(:course_id)
    @user = Student.find(session[:user_id])
  end
end
