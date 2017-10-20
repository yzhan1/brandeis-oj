class CoursesController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy, :index, :new]
  before_action :correct_user, only: [:show]
  before_action :can_edit, only: [:edit, :update, :destroy]
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  # GET /courses
  def index
    @courses = Course.all
  end

  # GET /courses/1
  def show
    @assignment_list = Assignment.where(course_id: @course.id)
    @enrollment_id = Enrollment.find_by(user_id: current_user.id, course_id: @course.id)
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
    @course = Course.new(course_params)
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
      redirect_to(dashboard_url, :flash => { :warning => 'Access denied' }) if @course.nil?
    end

    def can_edit
      @course = current_user.courses.find_by(id: params[:id])
      authorized = @course.enrolled_user?(current_user) && !is_student?
      # cannot edit a course if current_user is not the teacher who's teaching this course
      redirect_to(dashboard_url, :flash => { :warning => 'Access denied' }) if @course.nil? || !authorized
    end
end
