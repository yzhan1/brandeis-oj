class CompileWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options :retry => false

  def perform submission_id
    submission = Submission.find(submission_id)
    result = submission.run
    store stdout: result
  end
end
