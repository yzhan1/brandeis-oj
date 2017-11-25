class JunitWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options :retry => false

  def perform(assignment_id, submission_id)
    assignment = Assignment.find(assignment_id)
    result = assignment.test_submission(assignment.lang, submission_id)
    puts "\n\n======================================\n\n#{result}\n\n"
    store sbm_id: submission_id
    store stdout: result
  end

end
