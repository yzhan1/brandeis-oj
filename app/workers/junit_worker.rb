class JunitWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options :retry => false

  def perform(assignment_id, submission_id, lock)
    num_tests = -1
    puts "The lock is of class: #{lock.class}"
    assignment = Assignment.find(assignment_id)
    submission = Submission.find(submission_id)
    name = submission.user.name
    out = assignment.test_submission(assignment.lang, submission_id)
    num = num_passed_tests(out, assignment)

    if num_tests == -1
      num_tests = assignment.num_unit_tests
    end

    submission.auto_grade = num
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
