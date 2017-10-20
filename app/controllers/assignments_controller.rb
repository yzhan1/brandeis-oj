class AssignmentsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  before_action :can_edit, only: [:edit, :update, :destroy]
  before_action :set_assignment, only: [:show, :edit, :update, :destroy]

  # GET /assignments
  def index
    @assignments = Assignment.all
  end

  # GET /assignments/1
  def show
    if is_student?
      @submission = @assignment.submissions.where(user_id: current_user.id).first
      if !@submission
        @submission = Submission.create(
          user_id: current_user.id,
          assignment_id: @assignment.id,
          source_code: @assignment.template,
          submitted: false
        )
      end
    else
      @submissions = @assignment.submissions
      @course = @assignment.course
    end
  end

  def save
    submission = Submission.find(submission_params[:id])
    submission.update(submission_params)
    flash[:success] = 'Code saved'
    redirect_to submission.assignment
  end

  def autosave
    submission = Submission.find(submission_params[:id])
    submission.update(submission_params)
  end

  # GET /assignments/new
  def new
    @assignment = Assignment.new
  end

  # GET /assignments/1/edit
  def edit
    params[:course_id] = @assignment.course.id
  end

  # POST /assignments
  def create
    @assignment = Assignment.new(assignment_params)
    respond_to do |format|
      if @assignment.save
        Announcemnet.create(name: "New Assignment: #{params[:assignment][:name]}", couse_id: params[:assignment][:course_id], announcement_body: "A new assignment has been created!", announcement_date: DateTime.now) # TODO check if this is workingk
        format.html { redirect_to @assignment.course, :flash => { :success => 'Assignment was successfully created.' } }
        format.json { render :show, status: :created, location: @assignment.course }
      else
        format.html { render :new }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assignments/1
  def update
    @assignment.update(assignment_params)
    # if @assignment.update(assignment_params)
    #   flash[:success] = "Assignment updated"
    #   redirect_to edit_assignment_path(@assignment, :course_id => @assignment.course.id)
    # else
    #   render 'edit'
    # end
  end

  # DELETE /assignments/1
  def destroy
    course = @assignment.course
    @assignment.destroy
    respond_to do |format|
      format.html { redirect_to course, :flash => { :success => 'Assignment was successfully deleted.' } }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assignment_params
      params.require(:assignment).permit(:name, :due_date, :course_id, :instructions, :template)
    end

    def submission_params
      params.require(:submission).permit(:source_code, :assignment_id, :id)
    end

    def correct_user
      @assignment = Assignment.find_by(id: params[:id])
      redirect_back(fallback_location: dashboard_url, :flash => { :warning => 'Access denied' }) unless @assignment.course.enrolled_user?(current_user)
    end

    def can_edit
      @assignment = Assignment.find_by(id: params[:id])
      authorized = @assignment.course.enrolled_user?(current_user) && !is_student?
      # cannot edit assignment if user is not teacher who's teaching this course
      redirect_back(fallback_location: dashboard_url, :flash => { :warning => 'Access denied' }) unless authorized
    end
end
