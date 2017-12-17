class JunitWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options :retry => false

  def perform(assignment_id, submission_id)
    num_tests = -1
    assignment = Assignment.find(assignment_id)
    submission = Submission.find(submission_id)
    puts "[INFO]: Running test for submission #{submission_id}, assignment #{assignment_id}."
    name = submission.user.name
    out = assignment.test_submission(assignment.lang, submission_id)
    puts "[INFO]: Result for submission #{submission_id} was =>#{out}<=."
    num = num_passed_tests(out, assignment)
    puts "[INFO]: Number of passed tests for submission #{submission_id} was #{num}."
    if num_tests == -1
      num_tests = assignment.num_unit_tests
    end
    puts "[INFO]: For submission #{submission_id}, number of tests is #{num_tests} and #{num} passed."
    if num_tests < 1
      submission.auto_grade = 0
      puts "[INFO]: New auto-grade is #{0}."
    else
      submission.auto_grade = (((num.to_f)/num_tests)*100).round(2)
      puts "[INFO]: New auto-grade is #{(num.to_f)/num_tests}."
    end

    submission.save
    puts "The num of tests is: #{num_tests.inspect}"
    if num_tests.nil?
      num_tests = 0
    end
    result = "#{name}: #{num}/#{num_tests}"
    store sbm_id: submission_id
    store stdout: result
  end

  private

    def num_passed_tests (out, assignment)
      if out.start_with?("NumSuccTests:")
        out.slice!("NumSuccTests:")
        arr = out.split(',')
        assignment.num_unit_tests = arr[0]
        assignment.save
        res = arr[1].to_i
      else
        res = 0
      end
    end

end
