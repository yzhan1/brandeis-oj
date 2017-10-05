class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  # GET /students
  # GET /students.json
  def index
    @students = Student.all
  end

  # GET /students/1
  # GET /students/1.json
  def show
  end

  # GET /students/new
  def new
    @user = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
    @user = Student.new(student_params)
    if @user.save
      log_in @user, true
      flash[:success] = "Welcome to AspirinX!"
      # redirect_to student_url(@user)
      redirect_to stdn_dashboard_path
    else
      render 'new'
    end
    # respond_to do |format|
    #   if @student.save
    #     format.html { redirect_to @student, notice: 'Student was successfully created.' }
    #     format.json { render :show, status: :created, location: @student }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @student.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def dashboard
    @user = Student.find(session[:user_id])
    @enrollment_list = Enrollment.where("student_id=#{@user.id}")
    @course_list = Array.new
    @enrollment_list.each_with_index do |course_code, i|
      #should be course_code, need to change in database
      @course_list.push Course.where("id=#{@enrollment_list[i].course_id}")[0]
    end
    @assignment_list = Assignment.all
    @submission_list = Submission.where(student_id: @user.id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @user = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
