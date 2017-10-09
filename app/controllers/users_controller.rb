class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to AspirinX!"
      redirect_to dashboard_url
    else
      render 'new'
    end
  end


  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def dashboard
    @user = User.find(session[:user_id])
    if @user.role == 'student'
      @enrollment_list = Enrollment.where("user_id=#{@user.id}")
      @course_list = Array.new
      @announcement_list = Array.new
      @assignment_list = Array.new
      @enrollment_list.each do |enrollment_data|
        @course_list.push Course.where("course_code='#{enrollment_data.course_code}'")[0]
        Announcement.where("course_code='#{enrollment_data.course_code}'").each do |announcement_data|
          @announcement_list.push announcement_data
        end
        Assignment.where("assignments.course_code='#{enrollment_data.course_code}'").each do |assignment_data|
          @assignment_list.push assignment_data
        end
      end
      @submission_list=Submission.where("user_id=#{@user.id}")
    else
      @course_list = Course.where("user_id=#{@user.id}")
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
    end
end
