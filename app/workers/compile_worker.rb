class CompileWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform(submission_id, user_code)
    submission = Submission.find(submission_id)
    # Added a parameter to detect the language of the submission
    result = submission.run(submission.assignment.lang, user_code)
    store stdout: result
  end

end
