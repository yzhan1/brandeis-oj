class AssignmentsController < ApplicationController
  before_action :logged_in_user
  before_action :set_assignment, only: [:show, :edit, :update, :destroy]

  # GET /assignments
  def index
    @assignments = Assignment.all
  end

  # GET /assignments/1
  def show
    @submission = Submission.where(assignment_id: @assignment.id, user_id: current_user.id).first
    if !@submission
      @submission = Submission.new(user_id: current_user.id, assignment_id: @assignment.id, 
                                   source_code: @assignment.template, submitted: false)
      @submission.save!
    end
    # need to delete this? in future
    @submissions = nil
  end

  def save
    # submission = Submission.new(submission_params.merge(:user_id => current_user.id)).save!
    # puts submission_params[:source_code]
    submission = Submission.find(submission_params[:id])
    submission.update(submission_params)
    # not final implementation!!
    flash[:success] = 'saved'
    redirect_to dashboard_url
  end

  # def update_submission
  #   @submission = Submission.find(params[:id])
  #   @submission.update(submission_params)
  #   # not final implementation!!
  #   flash[:success] = 'saved'
  #   redirect_to dashboard_url
  # end

  # GET /assignments/new
  def new
    @assignment = Assignment.new
  end

  # GET /assignments/1/edit
  def edit
  end

  # POST /assignments
  def create
    @assignment = Assignment.new(assignment_params)
    respond_to do |format|
      if @assignment.save
        format.html { redirect_to @assignment, notice: 'Assignment was successfully created.' }
        format.json { render :show, status: :created, location: @assignment }
      else
        format.html { render :new }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assignments/1
  def update
    if @assignment.update(assignment_params)
      flash[:success] = "Assignment updated"
      redirect_to @assignment
    else
      render 'edit'
    end
  end

  # DELETE /assignments/1
  def destroy
    @assignment.destroy
    respond_to do |format|
      format.html { redirect_to assignments_url, notice: 'Assignment was successfully destroyed.' }
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
      params.require(:assignment).permit(:due_date, :course_code, :instructions, :template)
    end

    def submission_params
      params.require(:submission).permit(:source_code, :assignment_id, :id)
    end
end
