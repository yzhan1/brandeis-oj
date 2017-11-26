module AssignmentsHelper

  def test_code(assignment_id)
    job_id = TestsWorker.perform_async(assignment_id)
    res = {"id" => job_id}
  end

  def test_completed?(job_id)
    if Sidekiq::Status::complete? job_id
      sub_list = Sidekiq::Status::get_all(job_id)["all_jobs"]
      sub_list = sub_list.split(',')
      puts "The parsed array is: #{sub_list.inspect}"
      sub_list.each do |sub_id|
        puts "sub_id is: #{sub_id}"
        if !Sidekiq::Status::complete? sub_id
          data = {"message" => "Processing"}
          return data
        end
      end
      temp = ""
      count = 0
      sub_list.each do |sub_id|
        count = count + 1
        temp = "#{temp}<br/>#{count}. #{Sidekiq::Status::get_all(sub_id)["stdout"]}"
      end
      temp = "#{temp}<br/>"
      data = {"output" => "#{temp}"}
    elsif !Sidekiq::Status::failed? job_id
      data = {"message" => "Processing"}
    else
      data = {"output" => "At least one test has failed."}
    end
  end

end
