class CoursesController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy, :index, :new, :grades]
  before_action :correct_user, only: [:show, :grades]
  before_action :can_edit, only: [:edit, :update, :destroy]
  before_action :can_create, only: [:new, :create]
  before_action :set_course, only: [:show, :edit, :update, :destroy, :grades, :get_csv]

  # GET /courses
  def index
    @courses = Course.all
  end

  # GET /courses/1
  def show
    @assignment_list = @course.assignments
    @enrollment_id = Enrollment.find_by user_id: current_user.id, course_id: @course.id
    if is_student?
      @submissions = current_user.submissions_for @assignment_list
      submitted = @submissions.map { |submission| submission.assignment.id }
      @assignment_list = @course.assignments.where.not id: submitted
    end
  end

  def grades
  end

  def get_csv
    csv_str = build_csv @course.enrollments
    respond_to do |format|
      format.csv {
        return send_data(csv_str, type: 'text/plain', filename: "#{@course.course_title}.csv", disposition: 'attachment')
      }
    end
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  def create
    all_params = course_params
    all_params[:permission] = SecureRandom.hex(10)
    @course = Course.new(all_params)
    respond_to do |format|
      if @course.save
        Enrollment.create(user_id: current_user.id, course_id: @course.id)
        format.html { redirect_to @course, :flash => { :success => 'Course was successfully created.' } }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, :flash => { :success => 'Course was successfully updated.' } }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    current_user.enrollments.where(course_id: @course.id).first.destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_url, :flash => { :success => 'Course was successfully deleted.' } }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:course_title, :course_code)
    end

    def correct_user
      @course = current_user.courses.find_by(id: params[:id])
      redirect_to(error_url, :flash => { :warning => 'Access denied' }) if @course.nil?
    end

    def can_create
      redirect_to(error_url, :flash => { :warning => 'Access denied' }) if is_student?
    end

    def can_edit
      @course = current_user.courses.find_by(id: params[:id])
      authorized = @course.enrolled_user?(current_user) && !is_student?
      # cannot edit a course if current_user is not the teacher who's teaching this course
      redirect_to(error_url, :flash => { :warning => 'Access denied' }) if @course.nil? || !authorized
    end
end
