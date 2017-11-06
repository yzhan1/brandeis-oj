class CompileWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform(submission_id)
    submission = Submission.find(submission_id)
    # Added a parameter to detect the language of the submission
    result = submission.run(submission.assignment.lang)
    store stdout: result
  end
end
