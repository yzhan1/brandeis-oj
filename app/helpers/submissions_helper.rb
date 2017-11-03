module SubmissionsHelper
  def run_code(submission_id)
    job_id = CompileWorker.perform_async(submission_id)
    puts "job_id = #{job_id}"
    res = {"id" => job_id}
  end

  def completed?(job_id)
    if Sidekiq::Status::complete? job_id
      data = {"output" => Sidekiq::Status::get_all(job_id)["stdout"].split("\n")}
    else
      data = {"message" => "Processing"}
    end
  end
end
