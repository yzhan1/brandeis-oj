class EnrollmentsController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy, :index, :new]
  before_action :set_enrollment, only: [:show, :edit, :update, :destroy]

  # GET /enrollments
  # GET /enrollments.json
  def index
    @enrollments = Enrollment.all
  end

  # GET /enrollments/1
  # GET /enrollments/1.json
  def show
  end

  # GET /enrollments/new
  def new
    @enrollment = Enrollment.new
  end

  # GET /enrollments/1/edit
  def edit
  end

  # POST /enrollments
  # POST /enrollments.json
  def create
    @enrollment = Enrollment.new(enrollment_params)
    respond_to do |format|
      if @enrollment.save
        format.html { redirect_to @enrollment, success: 'Enrollment was successfully created.' }
        format.json { render :show, status: :created, location: @enrollment }
      else
        format.html { render :new }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_enrollment_dashboard
    enroll_course params[:enrollment][:course_id] # Even though the course_id is passed, the user should input the course_code. Need to know how to use forms better.
    redirect_to root_url
  end

  # PATCH/PUT /enrollments/1
  # PATCH/PUT /enrollments/1.json
  def update
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to @enrollment, success: 'Enrollment was successfully updated.' }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1
  # DELETE /enrollments/1.json
  def destroy
    @enrollment.destroy
    respond_to do |format|
      format.html { redirect_to root_url, success: 'Enrollment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enrollment
      @enrollment = Enrollment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def enrollment_params
      params.require(:enrollment).permit(:student_id, :course_code, :final_grade, :permission)
    end

    def enroll_course permission
      if !Course.where(permission: permission).nil? && !Course.where(permission: permission).first.nil?
        new_enrollment = Enrollment.new(course_id: Course.where(permission: permission).first.id, user_id: session[:user_id])
        new_enrollment.save
      end
    end
end
