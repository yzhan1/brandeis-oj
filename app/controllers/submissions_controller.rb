class SubmissionsController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy, :index, :new]  
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  before_action :set_submission, only: [:show, :edit, :update, :destroy, :run]

  # GET /submissions
  def index
    @submissions = Submission.all
  end

  # GET /submissions/1
  def show
  end

  # GET /submissions/new
  def new
    @submission = Submission.new
  end

  # GET /submissions/1/edit
  def edit
  end

  def save_or_run
    submission = Submission.find submission_params[:id]
    sub_attr = submission_params.merge submission_date: Time.now
    submission.update sub_attr
    run? ? do_run(submission.id) : do_save(submission)
  end

  def do_save submission
    if submission.assignment.pass_due?
      redirect_to submission.assignment.course, :flash => { :error => 'You cannot submit after due date has passed' }
    else
      submission.update submitted: true
      redirect_to submission.assignment.course, :flash => { :success => 'Assignment submitted' }
    end
  end
  
  def run
    do_run @submission.id
  end

  def do_run submission_id
    res = run_code(submission_id)
    respond_to do |format|
      format.json { render json: res }
    end
  end

  def autosave
    Submission.find(submission_params[:id]).update(submission_params)
  end

  # POST /submissions
  def create
    @submission = Submission.new(submission_params)
    respond_to do |format|
      if @submission.save
        format.html { redirect_to @submission, :flash => { :success => 'Submission was successfully created.' } }
        format.json { render :show, status: :created, location: @submission }
      else
        format.html { render :new }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /submissions/1
  def update
    respond_to do |format|
      if @submission.update(submission_params)
        format.html { redirect_to @submission }
        format.js { render :js => "toastr.success('Submission updated')" }
      else
        format.html { render @submission }
        format.js { render js => "toastr.error('Please enter all fields')" }
      end
    end
  end

  # DELETE /submissions/1
  def destroy
    @submission.destroy
    respond_to do |format|
      format.html { redirect_to submissions_url, :flash => { :success => 'Submission was successfully deleted.' } }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_submission
      @submission = Submission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def submission_params
      params.require(:submission).permit(:id, :submitted, :user_id, :assignment_id, :submission_date, :source_code, :grade, :comments)
    end

    def correct_user
      @submission = Submission.find_by(id: params[:id])
      instructor_access = !is_student? && @submission.assignment.course.enrolled_user?(current_user)
      # cannot view or edit a submission if user is not the teacher teaching this course or not the student who owns this submission
      redirect_to(dashboard_url, :flash => { :warning => 'Access denied'} ) unless @submission.user == current_user || instructor_access              
    end

    def run?
      params.require(:submission).permit(:run)[:run] == '1' ? true : false
    end
end
