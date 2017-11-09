class JunitWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform(assignment_id)
    assignment = Assignment.find(assignment_id)
    # Added a parameter to detect the language of the submission
    result = assignment.test_submission(assignment.lang)
    store stdout: result
  end

end
