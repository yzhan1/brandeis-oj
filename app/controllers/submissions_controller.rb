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
    submission.update(source_code: params[:submission][:code][:source_code])
    sub_attr = submission_params.merge(submission_date: Time.now)
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
    @code = Code.where(submission_id: params[:submission][:id]).where(filename: "Solution.java")
    @code.update(source_code: params[:submission][:code][:source_code])
    Submission.find(submission_params[:id]).update(submission_params.merge submission_date: Time.now)
  end

  def new_code
    @submission = Submission.where(id: params[:submission_id]).first
    @code = @submission.codes.create(source_code: @submission.assignment.template, filename: params[:filename])
  end

  def delete_code
    @submission = Submission.where(id: params[:submission_id]).first
    @code = @submission.codes.where(filename: params[:filename]).first
    @code.destroy
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
      count = @submission.grade == nil ? 1 : 0
      puts "submission grade is #{@submission.grade}, count is #{count}"
      if @submission.update(submission_params)
        enrollment = @submission.assignment.course.enrollments.find @submission.user.id
        enrollment.update(total: enrollment.total + @submission.grade, count: enrollment.count + count)
        enrollment.update(grade: enrollment.total / enrollment.count)
        @submission.send_notification

        format.html { redirect_to @submission }
        format.js { render :js => "toastr.success('Submission updated')" }
      else
        format.html { render @submission }
        format.js { render :js => "toastr.error('Please enter all fields')" }
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
      params.require(:submission).permit(:id, :submitted, :user_id, :assignment_id, :submission_date, :grade, :comments, codes_attributes: [:source_code])
    end

    def correct_user
      set_submission
      instructor_access = !is_student? && @submission.assignment.course.enrolled_user?(current_user)
      authorized = @submission.user == current_user || instructor_access
      # cannot view or edit a submission if user is not the teacher teaching this course or not the student who owns this submission
      redirect_to(error_url, :flash => { :warning => 'Access denied'} ) unless authorized
    end

    def run?
      params.require(:submission).permit(:run)[:run] == '1'
    end
end
