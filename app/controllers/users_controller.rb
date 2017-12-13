class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :dashboard]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  before_action :can_announce, only: [:create_announcement]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    return redirect_to dashboard_url, :flash => { :warning => 'You logged in already' } if logged_in?
    @user = User.new
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
      flash[:error] = "Please complete all fields"
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
    return redirect_to root_url, flash: { error: 'Pleas log in first' } if @user.nil?
    @enrollment = Enrollment.new
    @course_list = @user.courses
    @announcement_list = @course_list.map { |course| course.announcements }.flatten 2
    @assignment_list = @course_list.map { |course| course.assignments }.flatten 2
    if is_student?
      @submission_list = @user.submissions.where(submitted: true)
      submitted = @submission_list.map { |submission| submission.assignment.id }
      @assignment_list = @assignment_list.select { |assignment| !submitted.include?(assignment.id) }
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, :flash => { :success => 'User was successfully deleted.' } }
      format.json { head :no_content }
    end
  end

  # GET /announce
  def create_announcement
    announcement = Announcement.new(name: announcent_params[:title], announcement_date: DateTime.now, announcement_body: announcent_params[:announcement_body], course_id: announcent_params[:course])
    announcement.save if announcement.valid?
    redirect_to dashboard_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      return @user = current_user || User.find(params[:id]) if logged_in?
      @user = nil
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :phone)
    end

    def correct_user
      @user = User.find_by(id: params[:id])
      # cannot edit other user's profile
      redirect_to(error_url, :flash => { :warning => 'Access denied' }) if @user.nil? || @user != current_user
    end

    def announcent_params
      params.require(:announcement).permit(:course, :announcement_body, :title)
    end

    def can_announce
      course = Course.find_by(id: announcent_params[:course])
      redirect_to(error_url, :flash => { :warning => 'Access denied' }) if !course.enrolled_user?(current_user)
    end
end
