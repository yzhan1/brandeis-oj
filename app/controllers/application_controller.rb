class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper, SubmissionsHelper, AssignmentsHelper

  def progress
    job_id = job_id_param[:id]
    puts "=====================XXXXXXXXXXXX"
    puts "the job_id is: #{job_id}"
    data = completed?(job_id)
    respond_to do |format|
      format.json { render json: data }
    end
  end

  def test_progress
    job_id = job_id_param[:id]
    puts "=====================XXXXXXXXXXXX"
    puts "the job_id is: #{job_id}"
    data = test_completed?(job_id)
    puts "Is the test completed? job_id: #{job_id}; data: #{data.inspect}"
    respond_to do |format|
      format.json { render json: data }
    end

  end

  private
    def logged_in_user
      unless logged_in?
        store_location
        flash[:warning] = "Please log in."
        redirect_to login_url
      end
    end

    def job_id_param
      params.permit(:id, :format)
    end
end
