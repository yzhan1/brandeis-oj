module AssignmentsHelper

  def test_code(assignment_id)
    job_id = JunitWorker.perform_async(assignment_id)
    puts "job_id = #{job_id}"
    res = {"id" => job_id}
  end

end
