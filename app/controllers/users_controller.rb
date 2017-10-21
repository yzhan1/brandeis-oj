class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    if logged_in?
      redirect_to dashboard_url, :flash => { :warning => 'You logged in already' }
    else
      @user = User.new
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
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
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, :flash => { :success => 'User was successfully updated.' } }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def dashboard
    @user = User.find(session[:user_id])
    @enrollment_list = Enrollment.where("user_id=#{@user.id}")
    @enrollment = Enrollment.new
    @course_list = Array.new
    @announcement_list = Array.new
    @assignment_list = Array.new
    @enrollment_list.each do |enrollment_data|
      @course_list.push Course.where("id='#{enrollment_data.course_id}'")[0]
        Announcement.where("course_id='#{enrollment_data.course_id}'").each do |announcement_data|
          @announcement_list.push announcement_data
        end
        Assignment.where("assignments.course_id='#{enrollment_data.course_id}'").each do |assignment_data|
        @assignment_list.push assignment_data
      end
    end
    @submission_list = Submission.where("user_id=#{@user.id} AND submitted")
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, :flash => { :success => 'User was successfully deleted.' } }
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

    def correct_user
      @user = User.find_by(id: params[:id])
      # cannot edit other user's profile
      redirect_to(dashboard_url, :flash => { :warning => 'Access denied' }) if @user.nil? || @user != current_user
    end
end
