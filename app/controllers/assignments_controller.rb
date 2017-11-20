class AssignmentsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  before_action :can_edit, only: [:edit, :update, :destroy]
  before_action :set_assignment, only: [:show, :edit, :update, :destroy, :run]

  # GET /assignments
  def index
    @assignments = Assignment.all
  end

  # GET /assignments/1
  def show
    if is_student?
      @submission = @assignment.submissions.where(user_id: current_user.id).first
      @submission ||= Submission.create(
        user_id: current_user.id,
        assignment_id: @assignment.id,
        submitted: false)
      @code ||= @submission.codes.create(source_code: @assignment.template)
    else
      @submissions = @assignment.submissions.where(submitted: true)
      @course = @assignment.course
    end
  end

  # GET /assignments/new
  def new
    @assignment = Assignment.new(lang: 'java')
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
        Announcement.create(name: "New Assignment: #{params[:assignment][:name]}", course_id: params[:assignment][:course_id], announcement_body: "A new assignment has been created!", announcement_date: DateTime.now) # TODO check if this is workingk
        format.html { redirect_to @assignment.course, flash: { success: 'Assignment was successfully created.' } }
        format.json { render :show, status: :created, location: @assignment.course }
      else
        format.html { render :new }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assignments/1
  def update
    respond_to do |format|
      if @assignment.update(assignment_params)
        format.html { redirect_to edit_assignment_path(@assignment, :course_id => @assignment.course.id) }
        format.js
      else
        format.html { redirect_to edit_assignment_path(@assignment, :course_id => @assignment.course.id) }
        format.js { render :js => "toastr.error('Please enter all fields')" }
      end
    end
  end

  # DELETE /assignments/1
  def destroy
    course = @assignment.course
    @assignment.destroy
    respond_to do |format|
      format.html { redirect_to course, flash: { success: 'Assignment was successfully deleted.' } }
      format.json { head :no_content }
    end
  end

  # GET /run_tests
  def run_tests
    puts "The params are ======== #{params.inspect}"
    # assignment = Assignment.find()
    # puts assignment.inspect
    # Up to here we have gotten the right assignment to run tests on
    puts "#{test_params[:id]} jjjjjjjjjjjjjjjj"
    res = test_code(test_params[:id])
    puts "XXXXXX: currently here => The res is: #{res}"
    message = "Automated testing is almost completed... hang in there!"
    respond_to do |format|
      format.json { render json: res }
    end
    # render js: "document.querySelector('#test-results').innerHTML = '#{message} The list of job ids: #{res}';"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assignment_params
      params.require(:assignment).permit(:name, :due_date, :course_id, :instructions, :template, :lang, :test_code, :pdf_instruction)
    end

    def test_params
      params.permit(:id)
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
