class CompileWorker
  include Sidekiq::Worker

  def perform(submission)
    result = submission.run
  end
end
