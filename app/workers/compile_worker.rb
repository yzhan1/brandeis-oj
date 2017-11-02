class CompileWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform(submission_id)
    puts "============================#{submission_id}=========================="
    submission = Submission.find(id: submission_id)
    puts "============================#{submission}=========================="
    result = submission.run.split("\n")
    store stdout: result
  end
end
