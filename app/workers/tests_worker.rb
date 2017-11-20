class TestsWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform(assignment_id)
    puts "#{assignment_id} afuewowefhwoihgewoifo fwoei fewo fwohfeihooihasflkslk"
    assignment = Assignment.find(assignment_id)
    list_of_submissions = assignment.submissions
    puts "list.... #{list_of_submissions}"
    # job_ids = Array.new
    job_ids = ""
    list_of_submissions.each do |submission|
      puts "#{assignment_id} from inside the loop: #{submission.inspect}"
      curr = JunitWorker.perform_async(assignment_id, submission.id)
      puts "the result from JUNIWORKER #{curr}"
      # job_ids.push(curr)
      if job_ids == ""
        job_ids = "#{curr}"
      else
        job_ids = "#{job_ids},#{curr}"
      end
    end
    store all_jobs: job_ids
  end

end
